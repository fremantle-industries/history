defmodule History.Trades.DownloadChunksBroadway do
  use Broadway
  require Logger
  alias Broadway.Message
  alias History.{TradeHistoryChunks, TradeHistoryJobs, Trades}

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {Trades.DownloadChunksProducer, []},
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
    |> Enum.map(fn m ->
      {chunk, new_status} = m.data
      {:ok, _} = TradeHistoryChunks.update(chunk, %{status: new_status})
      broadcast_update(chunk, new_status)
      chunk.job_id
    end)
    |> Enum.uniq()
    |> Enum.each(fn job_id ->
      total_chunks = TradeHistoryChunks.count_by_job_id(job_id)
      total_complete = TradeHistoryChunks.count_by_job_id_and_status(job_id, :complete)
      total_error = TradeHistoryChunks.count_by_job_id_and_status(job_id, :error)
      total_not_found = TradeHistoryChunks.count_by_job_id_and_status(job_id, :not_found)

      if total_chunks == total_complete + total_error + total_not_found do
        job = TradeHistoryJobs.get!(job_id)

        job_status =
          if total_error > 0 do
            "error"
          else
            "complete"
          end

        TradeHistoryJobs.update(job, %{status: job_status})
        Trades.PubSub.broadcast_update(job.id, job_status)
      end
    end)

    failed
    |> Enum.each(fn m ->
      Logger.error(
        "could not download chunk - id: #{m.data.id}, venue: #{m.data.venue}, product: #{m.data.product}"
      )

      TradeHistoryChunks.update(m.data, %{status: "error"})
      broadcast_update(m.data, "error")
    end)

    :ok
  end

  defp process_data(chunk) do
    case TradeHistoryChunks.fetch(chunk) do
      {:ok, trades} ->
        trades
        |> Enum.each(fn t ->
          {:ok, _} =
            Trades.upsert(%{
              time: t.time,
              venue: chunk.venue,
              product: chunk.product,
              venue_order_id: "#{t.id}",
              side: t.side,
              price: Tai.Utils.Decimal.cast!(t.price),
              qty: Tai.Utils.Decimal.cast!(t.size),
              liquidation: t.liquidation,
              source: "api"
            })
        end)

        {chunk, "complete"}

      {:error, :not_found} ->
        {chunk, "not_found"}

      {:error, :not_supported} ->
        {chunk, "error"}
    end
  end

  @topic_prefix "trade_history_chunk"
  defp broadcast_update(chunk, status) do
    topics = ["#{@topic_prefix}:*", "#{@topic_prefix}:#{chunk.id}"]
    msg = {:trade_history_chunk, :update, %{id: chunk.id, status: status}}

    topics
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(Tai.PubSub, topic, msg)
    end)
  end
end
