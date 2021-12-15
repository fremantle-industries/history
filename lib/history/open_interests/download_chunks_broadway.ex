defmodule History.OpenInterests.DownloadChunksBroadway do
  use Broadway
  require Logger
  alias Broadway.Message
  alias History.{OpenInterestHistoryChunks, OpenInterestHistoryJobs, OpenInterests}

  @default_concurrency 2

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    processor_concurrency = Application.get_env(:history, :download_open_interest_concurrency, @default_concurrency)

    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {OpenInterests.DownloadChunksProducer, []},
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
      {:ok, _} = OpenInterestHistoryChunks.update(chunk, %{status: new_status})
      broadcast_update(chunk, new_status)
      chunk.job_id
    end)
    |> Enum.uniq()
    |> Enum.each(fn job_id ->
      total_chunks = OpenInterestHistoryChunks.count_by_job_id(job_id)
      total_complete = OpenInterestHistoryChunks.count_by_job_id_and_status(job_id, :complete)
      total_error = OpenInterestHistoryChunks.count_by_job_id_and_status(job_id, :error)
      total_not_found = OpenInterestHistoryChunks.count_by_job_id_and_status(job_id, :not_found)

      if total_chunks == total_complete + total_error + total_not_found do
        job = OpenInterestHistoryJobs.get!(job_id)

        job_status =
          if total_error > 0 do
            "error"
          else
            "complete"
          end

        case OpenInterestHistoryJobs.update(job, %{status: job_status}) do
          {:ok, job} -> OpenInterestHistoryJobs.broadcast(job.id, job.status)
        end
      end
    end)

    failed
    |> Enum.each(fn m ->
      Logger.error(
        "could not download chunk - id: #{m.data.id}, venue: #{m.data.venue}, product: #{m.data.product}"
      )

      OpenInterestHistoryChunks.update(m.data, %{status: "error"})
      broadcast_update(m.data, "error")
    end)

    :ok
  end

  defp process_data(chunk) do
    case OpenInterestHistoryChunks.fetch(chunk) do
      {:ok, open_interest} ->
        OpenInterests.upsert(%{
          venue: chunk.venue,
          symbol: chunk.symbol,
          value: open_interest.value
        })

        {chunk, "complete"}

      {:error, :not_found} ->
        {chunk, "not_found"}

      {:error, :not_supported} ->
        {chunk, "error"}
    end
  end

  @topic_prefix "open_interest_history_chunk"
  defp broadcast_update(chunk, status) do
    topics = ["#{@topic_prefix}:*", "#{@topic_prefix}:#{chunk.id}"]
    msg = {:open_interest_history_chunk, :update, %{id: chunk.id, status: status}}

    topics
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(Tai.PubSub, topic, msg)
    end)
  end
end
