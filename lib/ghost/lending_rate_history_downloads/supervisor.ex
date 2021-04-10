defmodule Ghost.LendingRateHistoryDownloads.Supervisor do
  use Supervisor

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(_) do
    children = []

    Supervisor.init(children, strategy: :one_for_one)
  end
end
