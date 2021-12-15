defmodule History.OpenInterests.CreateChunksBroadway do
  use Broadway
  require Logger
  alias Broadway.Message

  alias History.{
    OpenInterests,
    OpenInterestHistoryJobs,
    OpenInterestHistoryChunks
  }

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {OpenInterests.CreateChunksProducer, []},
        transformer: {__MODULE__, :transform, []}
      ],
      processors: [
        default: [concurrency: 1]
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
      case OpenInterestHistoryJobs.update(m.data, %{status: "working"}) do
        {:ok, job} -> OpenInterestHistoryJobs.broadcast(job.id, job.status)
      end
    end)

    failed
    |> Enum.each(fn m ->
      "could not create chunks for job id=~w"
      |> :io_lib.format([m.data.id])
      |> Logger.error()
    end)

    :ok
  end

  defp process_data(job) do
    job |> each_chunk(&OpenInterestHistoryChunks.insert/1)
    job
  end

  def each_chunk(job, callback) do
    job.tokens
    |> Enum.each(fn token ->
      build_each_chunk(job, token, callback)
    end)
  end

  defp build_each_chunk(job, token, callback) do
    chunk = %OpenInterests.OpenInterestHistoryChunk{
      status: "enqueued",
      job: job,
      token_name: token.name,
      token_symbol: token.symbol,
    }

    callback.(chunk)
  end
end
