defmodule History.Trades.Supervisor do
  use Supervisor
  alias History.Trades

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(_) do
    children = [
      {Trades.CreateChunksBroadway, []},
      {Trades.DownloadChunksBroadway, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
