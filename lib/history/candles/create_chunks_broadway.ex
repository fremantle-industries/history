defmodule History.Candles.CreateChunksBroadway do
  use Broadway
  require Logger
  alias Broadway.Message

  alias History.{
    Candles,
    CandleHistoryJobs,
    CandleHistoryChunks,
    DataAdapter,
    RangeJob
  }

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {Candles.CreateChunksProducer, []},
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
      {:ok, _} = CandleHistoryJobs.update(m.data, %{status: "working"})
      Candles.PubSub.broadcast_update(m.data.id, "working")
    end)

    failed
    |> Enum.each(fn m ->
      Logger.error("could not create chunks for job: #{m.data.id}")
    end)

    :ok
  end

  defp process_data(job) do
    job |> each_chunk(&CandleHistoryChunks.insert/1)
    job
  end

  def each_chunk(job, callback) do
    {:ok, start_at} = RangeJob.from(job)
    {:ok, end_at} = RangeJob.to(job)

    job.products
    |> Enum.map(fn p -> {p.venue, p.symbol} end)
    |> History.Products.by_venue_and_symbol()
    |> Enum.each(fn product ->
      {:ok, candle_adapter} = DataAdapter.for_venue(product.venue, :candles)

      job.periods
      |> Enum.each(fn period ->
        with {:ok, chunk_range} <- candle_adapter.chunk_range(period) do
          build_each_chunk(job, product, start_at, end_at, period, chunk_range, callback)
        end
      end)
    end)
  end

  defp build_each_chunk(job, product, job_start_at, job_end_at, period, chunk_range, callback) do
    if Timex.before?(job_start_at, job_end_at) do
      chunk_end_at = DateTime.add(job_start_at, chunk_range, :second)
      min_chunk_end_at = Tai.DateTime.min(chunk_end_at, job_end_at)

      chunk = %Candles.CandleHistoryChunk{
        status: "enqueued",
        job: job,
        venue: product.venue,
        product: product.symbol,
        start_at: job_start_at,
        end_at: min_chunk_end_at,
        period: period
      }

      callback.(chunk)

      build_each_chunk(
        job,
        product,
        min_chunk_end_at,
        job_end_at,
        period,
        chunk_range,
        callback
      )
    end
  end
end
