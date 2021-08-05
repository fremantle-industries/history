defmodule History.LendingRateHistoryJobs.CreateChunksBroadway do
  use Broadway
  require Logger
  alias Broadway.Message
  alias History.LendingRateHistoryChunks
  alias History.LendingRateHistoryJobs
  alias History.LendingRateHistoryJobs.CreateChunksProducer

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
      {:ok, _} = LendingRateHistoryJobs.update(m.data, %{status: "working"})
      LendingRateHistoryJobs.PubSub.broadcast_update(m.data.id, "working")
    end)

    failed
    |> Enum.each(fn m ->
      Logger.error("could not create chunks for job: #{m.data.id}")
    end)

    :ok
  end

  defp process_data(job) do
    job
    |> LendingRateHistoryJobs.each_chunk(&LendingRateHistoryChunks.insert/1)

    job
  end
end
