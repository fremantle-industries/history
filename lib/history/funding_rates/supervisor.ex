defmodule History.FundingRates.Supervisor do
  use Supervisor
  alias History.FundingRates

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(_) do
    children = [
      {FundingRates.CreateChunksBroadway, []},
      {FundingRates.DownloadChunksBroadway, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
