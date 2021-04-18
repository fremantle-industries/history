defmodule Ghost.FundingRateHistoryJobs.DownloadChunksBroadway do
  use Broadway
  require Logger
  alias Broadway.Message
  alias Ghost.FundingRateHistoryChunks
  alias Ghost.FundingRateHistoryJobs
  alias Ghost.FundingRates

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {FundingRateHistoryJobs.DownloadChunksProducer, []},
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
      FundingRateHistoryChunks.update(m.data, %{status: "complete"})
      broadcast_update(m.data, "complete")
      m.data.job_id
    end)
    |> Enum.uniq()
    |> Enum.each(fn job_id ->
      total_chunks = FundingRateHistoryChunks.count_by_job_id(job_id)
      total_complete = FundingRateHistoryChunks.count_by_job_id_and_status(job_id, :complete)
      total_error = FundingRateHistoryChunks.count_by_job_id_and_status(job_id, :error)

      if total_chunks == total_complete + total_error do
        job = FundingRateHistoryJobs.get!(job_id)
        job_status = if total_error == 0, do: "complete", else: "error"
        FundingRateHistoryJobs.update(job, %{status: job_status})
        FundingRateHistoryJobs.PubSub.broadcast_update(job.id, job_status)
      end
    end)

    failed
    |> Enum.each(fn m ->
      Logger.error(
        "could not download chunk - id: #{m.data.id}, venue: #{m.data.venue}, product: #{
          m.data.product
        }"
      )

      FundingRateHistoryChunks.update(m.data, %{status: "error"})
      broadcast_update(m.data, "complete")
    end)

    :ok
  end

  defp process_data(chunk) do
    {:ok, rates} = FundingRateHistoryChunks.fetch(chunk)

    rates
    |> Enum.each(fn r ->
      {:ok, _} =
        FundingRates.upsert(%{
          time: r.time,
          rate: r.rate,
          venue: chunk.venue,
          product: chunk.product,
          base: "-",
          quote: "-"
        })
    end)

    chunk
  end

  @topic_prefix "funding_rate_history_chunk"
  defp broadcast_update(chunk, status) do
    topics = ["#{@topic_prefix}:*", "#{@topic_prefix}:#{chunk.id}"]
    msg = {:funding_rate_history_chunk, :update, %{id: chunk.id, status: status}}

    topics
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(Ghost.PubSub, topic, msg)
    end)
  end
end
