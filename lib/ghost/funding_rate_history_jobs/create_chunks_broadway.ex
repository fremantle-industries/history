defmodule Ghost.FundingRateHistoryJobs.CreateChunksBroadway do
  use Broadway
  require Logger
  alias Broadway.Message
  alias Ghost.FundingRateHistoryChunks
  alias Ghost.FundingRateHistoryJobs
  alias Ghost.FundingRateHistoryJobs.CreateChunksProducer

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {CreateChunksProducer, []},
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
      {:ok, _} = FundingRateHistoryJobs.update(m.data, %{status: "working"})
      broadcast_update(m.data, "working")
    end)

    failed
    |> Enum.each(fn m ->
      Logger.error("could not create chunks for job: #{m.data.id}")
    end)

    :ok
  end

  defp process_data(job) do
    job
    |> FundingRateHistoryJobs.each_chunk(&FundingRateHistoryChunks.insert/1)

    job
  end

  @topic_prefix "funding_rate_history_job"
  defp broadcast_update(job, status) do
    topics = ["#{@topic_prefix}:*", "#{@topic_prefix}:#{job.id}"]
    msg = {:funding_rate_history_job, :update, %{id: job.id, status: status}}

    topics
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(Ghost.PubSub, topic, msg)
    end)
  end
end
