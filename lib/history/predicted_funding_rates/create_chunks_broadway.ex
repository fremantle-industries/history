defmodule History.PredictedFundingRates.CreateChunksBroadway do
  use Broadway
  require Logger
  alias Broadway.Message
  alias History.{PredictedFundingRates, PredictedFundingRateJobs, PredictedFundingRateChunks}

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {PredictedFundingRates.CreateChunksProducer, []},
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
      {:ok, _} = PredictedFundingRateJobs.update(m.data, %{status: "working"})
      PredictedFundingRates.PubSub.broadcast_update(m.data.id, "working")
    end)

    failed
    |> Enum.each(fn m ->
      Logger.error("could not create chunks for job: #{m.data.id}")
    end)

    :ok
  end

  defp process_data(job) do
    job
    |> PredictedFundingRateJobs.each_chunk(&PredictedFundingRateChunks.insert/1)

    job
  end
end
