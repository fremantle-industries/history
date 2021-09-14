defmodule History.PredictedFundingRates.DownloadChunksBroadway do
  use Broadway
  require Logger
  alias Broadway.Message
  alias History.{PredictedFundingRateChunks, PredictedFundingRateJobs, PredictedFundingRates}

  @default_concurrency 2

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    processor_concurrency = Application.get_env(:history, :download_predicted_funding_rate_concurrency, @default_concurrency)

    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {PredictedFundingRates.DownloadChunksProducer, []},
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
      {:ok, _} = PredictedFundingRateChunks.update(chunk, %{status: new_status})
      broadcast_update(chunk, new_status)
      chunk.job_id
    end)
    |> Enum.uniq()
    |> Enum.each(fn job_id ->
      total_chunks = PredictedFundingRateChunks.count_by_job_id(job_id)
      total_complete = PredictedFundingRateChunks.count_by_job_id_and_status(job_id, :complete)
      total_error = PredictedFundingRateChunks.count_by_job_id_and_status(job_id, :error)
      total_not_found = PredictedFundingRateChunks.count_by_job_id_and_status(job_id, :not_found)

      if total_chunks == total_complete + total_error + total_not_found do
        job = PredictedFundingRateJobs.get!(job_id)

        job_status =
          if total_error > 0 do
            "error"
          else
            "complete"
          end

        PredictedFundingRateJobs.update(job, %{status: job_status})
        PredictedFundingRates.PubSub.broadcast_update(job.id, job_status)
      end
    end)

    failed
    |> Enum.each(fn m ->
      Logger.error(
        "could not download chunk - id: #{m.data.id}, venue: #{m.data.venue}, product: #{m.data.product}"
      )

      PredictedFundingRateChunks.update(m.data, %{status: "error"})
      broadcast_update(m.data, "error")
    end)

    :ok
  end

  defp process_data(chunk) do
    case PredictedFundingRateChunks.fetch(chunk) do
      {:ok, stats} ->
        {:ok, _} =
          PredictedFundingRates.upsert(%{
            next_funding_time: stats.next_funding_time,
            next_funding_rate: stats.next_funding_rate,
            venue: chunk.venue,
            product: chunk.product,
            base: "-",
            quote: "-"
          })

        {chunk, "complete"}

      {:error, :not_found} ->
        {chunk, "not_found"}

      {:error, :not_supported} ->
        {chunk, "error"}
    end
  end

  @topic_prefix "predicted_funding_rate_chunk"
  defp broadcast_update(chunk, status) do
    topics = ["#{@topic_prefix}:*", "#{@topic_prefix}:#{chunk.id}"]
    msg = {:predicted_funding_rate_chunk, :update, %{id: chunk.id, status: status}}

    topics
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(Tai.PubSub, topic, msg)
    end)
  end
end
