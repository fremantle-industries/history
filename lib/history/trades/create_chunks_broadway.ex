defmodule History.Trades.CreateChunksBroadway do
  use Broadway
  require Logger
  alias Broadway.Message

  alias History.{
    DataAdapter,
    RangeJob,
    Trades,
    TradeHistoryJobs,
    TradeHistoryChunks
  }

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {Trades.CreateChunksProducer, []},
        transformer: {__MODULE__, :transform, []}
      ],
      processors: [
        default: [concurrency: 2]
      ]
    )
  end

  @impl true
  def handle_message(_, message, _) do
    message
    |> Message.update_data(&process_data/1)
  end

  def transform(event, _opts) do
    %Message{
      data: event,
      acknowledger: {__MODULE__, :ack_id, :ack_data}
    }
  end

  def ack(:ack_id, successful, failed) do
    successful
    |> Enum.each(fn m ->
      {:ok, _} = TradeHistoryJobs.update(m.data, %{status: "working"})
      Trades.PubSub.broadcast_update(m.data.id, "working")
    end)

    failed
    |> Enum.each(fn m ->
      Logger.error("could not create chunks for job: #{m.data.id}")
    end)

    :ok
  end

  defp process_data(job) do
    job |> each_chunk(&TradeHistoryChunks.insert/1)
    job
  end

  defp each_chunk(job, callback) do
    {:ok, start_at} = RangeJob.from(job)
    {:ok, end_at} = RangeJob.to(job)

    job.products
    |> Enum.map(fn p -> {p.venue, p.symbol} end)
    |> History.Products.by_venue_and_symbol()
    |> Enum.each(fn p ->
      with {:ok, trade_adapter} = DataAdapter.for_venue(p.venue, :trades),
           {:ok, period} <- trade_adapter.period(),
           {:ok, periods_per_chunk} = trade_adapter.periods_per_chunk() do
        build_each_chunk(
          job,
          p.venue,
          p.symbol,
          start_at,
          end_at,
          period,
          periods_per_chunk,
          callback
        )
      end
    end)
  end

  defp build_each_chunk(
         job,
         venue,
         product_symbol,
         start_at,
         end_at,
         period,
         periods_per_chunk,
         callback
       ) do
    if Timex.before?(start_at, end_at) do
      chunk_end_at = DateTime.add(start_at, period * periods_per_chunk, :second)
      min_chunk_end_at = Tai.DateTime.min(chunk_end_at, end_at)

      chunk = %Trades.TradeHistoryChunk{
        status: "enqueued",
        job: job,
        venue: venue,
        product: product_symbol,
        start_at: start_at,
        end_at: min_chunk_end_at
      }

      callback.(chunk)

      build_each_chunk(
        job,
        venue,
        product_symbol,
        min_chunk_end_at,
        end_at,
        period,
        periods_per_chunk,
        callback
      )
    end
  end
end
