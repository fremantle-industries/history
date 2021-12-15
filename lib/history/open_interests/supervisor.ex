defmodule History.OpenInterests.Supervisor do
  use Supervisor
  alias History.OpenInterests

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(_) do
    children = [
      {OpenInterests.CreateChunksBroadway, []},
      {OpenInterests.DownloadChunksBroadway, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
