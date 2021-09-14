defmodule History.Candles.DownloadChunksBroadway do
  use Broadway
  require Logger
  alias Broadway.Message
  alias History.{CandleHistoryChunks, CandleHistoryJobs, Candles}

  @default_concurrency 2

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    processor_concurrency = Application.get_env(:history, :download_candle_chunks_concurrency, @default_concurrency)

    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {Candles.DownloadChunksProducer, []},
        transformer: {__MODULE__, :transform, []}
      ],
      processors: [
        default: [concurrency: processor_concurrency]
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
      {:ok, _} = CandleHistoryChunks.update(chunk, %{status: new_status})
      broadcast_update(chunk, new_status)
      chunk.job_id
    end)
    |> Enum.uniq()
    |> Enum.each(fn job_id ->
      total_chunks = CandleHistoryChunks.count_by_job_id(job_id)
      total_complete = CandleHistoryChunks.count_by_job_id_and_status(job_id, :complete)
      total_error = CandleHistoryChunks.count_by_job_id_and_status(job_id, :error)
      total_not_found = CandleHistoryChunks.count_by_job_id_and_status(job_id, :not_found)

      if total_chunks == total_complete + total_error + total_not_found do
        job = CandleHistoryJobs.get!(job_id)

        job_status =
          if total_error > 0 do
            "error"
          else
            "complete"
          end

        CandleHistoryJobs.update(job, %{status: job_status})
        Candles.PubSub.broadcast_update(job.id, job_status)
      end
    end)

    failed
    |> Enum.each(fn m ->
      Logger.error(
        "could not download chunk - id: #{m.data.id}, venue: #{m.data.venue}, product: #{m.data.product}"
      )

      CandleHistoryChunks.update(m.data, %{status: "error"})
      broadcast_update(m.data, "error")
    end)

    :ok
  end

  defp process_data(chunk) do
    case CandleHistoryChunks.fetch(chunk) do
      {:ok, candles} ->
        candles
        |> Enum.each(fn c ->
          {:ok, time, _} = DateTime.from_iso8601(c.start_time)

          {:ok, _} =
            Candles.upsert(%{
              time: time,
              venue: chunk.venue,
              product: chunk.product,
              source: "api",
              period: chunk.period,
              open: Tai.Utils.Decimal.cast!(c.open),
              high: Tai.Utils.Decimal.cast!(c.high),
              low: Tai.Utils.Decimal.cast!(c.low),
              close: Tai.Utils.Decimal.cast!(c.close),
              volume: Tai.Utils.Decimal.cast!(c.volume)
            })
        end)

        {chunk, "complete"}

      {:error, :not_found} ->
        {chunk, "not_found"}

      {:error, :not_supported} ->
        Logger.debug(
          "fetch candle history chunk not supported by job: #{chunk.job_id}, chunk: #{chunk.id}"
        )

        {chunk, "error"}

      {:error, reason} ->
        Logger.error(
          "fetch candle history chunk error for job: #{chunk.job_id}, chunk: #{chunk.id}, reason: #{inspect(reason)}"
        )

        {chunk, "error"}
    end
  end

  @topic_prefix "candle_history_chunk"
  defp broadcast_update(chunk, status) do
    topics = ["#{@topic_prefix}:*", "#{@topic_prefix}:#{chunk.id}"]
    msg = {:candle_history_chunk, :update, %{id: chunk.id, status: status}}

    topics
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(Tai.PubSub, topic, msg)
    end)
  end
end
