defmodule History.Advisors.Recorder.Advisor do
  use Tai.Advisor
  require Logger

  @impl true
  def handle_trade(trade, run_store) do
    Logger.info "----------- HANDLE trade: #{inspect trade}"
    {:ok, run_store}
  end
end
