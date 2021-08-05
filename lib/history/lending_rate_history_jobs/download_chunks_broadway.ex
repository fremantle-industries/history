defmodule History.LendingRateHistoryJobs.DownloadChunksBroadway do
  use Broadway
  require Logger
  alias Broadway.Message
  alias History.LendingRateHistoryChunks
  alias History.LendingRateHistoryJobs
  alias History.LendingRates

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {LendingRateHistoryJobs.DownloadChunksProducer, []},
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
      LendingRateHistoryChunks.update(m.data, %{status: "complete"})
      broadcast_update(m.data, "complete")
      m.data.job_id
    end)
    |> Enum.uniq()
    |> Enum.each(fn job_id ->
      total_chunks = LendingRateHistoryChunks.count_by_job_id(job_id)
      total_complete = LendingRateHistoryChunks.count_by_job_id_and_status(job_id, :complete)
      total_error = LendingRateHistoryChunks.count_by_job_id_and_status(job_id, :error)

      if total_chunks == total_complete + total_error do
        job = LendingRateHistoryJobs.get!(job_id)
        job_status = if total_error == 0, do: "complete", else: "error"
        LendingRateHistoryJobs.update(job, %{status: job_status})
        LendingRateHistoryJobs.PubSub.broadcast_update(job.id, job_status)
      end
    end)

    failed
    |> Enum.each(fn m ->
      Logger.error(
        "could not download chunk - id: #{m.data.id}, venue: #{m.data.venue}, token: #{m.data.token}"
      )

      LendingRateHistoryChunks.update(m.data, %{status: "error"})
      broadcast_update(m.data, "complete")
    end)

    :ok
  end

  defp process_data(chunk) do
    {:ok, rates} = LendingRateHistoryChunks.fetch(chunk)

    rates
    |> Enum.each(fn r ->
      {:ok, _} =
        LendingRates.upsert(%{
          time: r.time,
          rate: r.rate,
          venue: chunk.venue,
          token: chunk.token,
          base: "-",
          quote: "-"
        })
    end)

    chunk
  end

  @topic_prefix "lending_rate_history_chunk"
  defp broadcast_update(chunk, status) do
    topics = ["#{@topic_prefix}:*", "#{@topic_prefix}:#{chunk.id}"]
    msg = {:lending_rate_history_chunk, :update, %{id: chunk.id, status: status}}

    topics
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(History.PubSub, topic, msg)
    end)
  end
end
