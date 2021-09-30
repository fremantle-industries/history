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
    Message.update_data(message, &process_data/1)
  end

  def transform(event, _opts) do
    %Message{
      data: event,
      acknowledger: {__MODULE__, :ack_id, :ack_data}
    }
  end

  def ack(:ack_id, successful, failed) do
    processed_chunk_job_ids = successful
                               |> Enum.map(fn m ->
                                 {chunk, new_status, error_reason} = m.data

                                 case CandleHistoryChunks.update(chunk, %{status: new_status}) do
                                   {:ok, chunk} -> CandleHistoryChunks.broadcast(chunk)
                                 end

                                 if error_reason != nil do
                                   "could not download or process chunk id=~w, venue=~s, product=~s, reason=~w"
                                   |> :io_lib.format([chunk.id, chunk.venue, chunk.product, error_reason])
                                   |> List.to_string()
                                   |> Logger.error()
                                 end

                                 chunk.job_id
                               end)

    # TODO: Not sure what the value of this will be
    failed
    |> Enum.map(fn f ->
      Logger.error "failed to ack #{inspect f}"
    end)


    processed_chunk_job_ids
    |> Enum.uniq()
    |> Enum.each(fn job_id ->
      total_chunks = CandleHistoryChunks.count_by_job_id(job_id)
      total_finished = CandleHistoryChunks.count_by_job_id_and_status(job_id, [:complete, :error, :not_found])

      if total_chunks == total_finished do
        job = CandleHistoryJobs.get!(job_id)
        total_error = CandleHistoryChunks.count_by_job_id_and_status(job_id, [:error])

        job_status =
          if total_error > 0 do
            "error"
          else
            "complete"
          end

        case CandleHistoryJobs.update(job, %{status: job_status}) do
          {:ok, job} -> CandleHistoryJobs.broadcast(job)
        end
      end
    end)

    :ok
  end

  defp process_data(chunk) do
    try do
      case CandleHistoryChunks.fetch(chunk) do
        {:ok, venue_candles} ->
          venue_candles
          |> Enum.map(&build_candle(&1, chunk))
          |> History.Candles.insert_all()

          {chunk, "complete", nil}

        {:error, :not_found} ->
          {chunk, "not_found", :not_found}

        {:error, :not_supported} ->
          {chunk, "error", :not_supported}

        {:error, reason} ->
          {chunk, "error", reason}
      end
    rescue
      error_reason -> 
        {chunk, "error", error_reason}
    end
  end

  defp build_candle(venue_candle, chunk) do
    {:ok, time, _} = DateTime.from_iso8601(venue_candle.start_time)

    %{
      time: time,
      venue: chunk.venue,
      product: chunk.product,
      source: "api",
      period: chunk.period,
      open: Tai.Utils.Decimal.cast!(venue_candle.open),
      high: Tai.Utils.Decimal.cast!(venue_candle.high),
      low: Tai.Utils.Decimal.cast!(venue_candle.low),
      close: Tai.Utils.Decimal.cast!(venue_candle.close),
      volume: Tai.Utils.Decimal.cast!(venue_candle.volume),
      inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    }
  end
end
