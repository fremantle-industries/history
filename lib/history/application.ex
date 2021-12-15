defmodule History.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Confex.resolve_env!(:history)

    children = [
      History.Repo,
      History.EtsRepo,
      HistoryWeb.Telemetry,
      HistoryWeb.Endpoint,
      History.Trades.Supervisor,
      History.Candles.Supervisor,
      History.OpenInterests.Supervisor,
      History.FundingRates.Supervisor,
      History.PredictedFundingRates.Supervisor,
      History.LendingRates.Supervisor
    ]

    opts = [strategy: :one_for_one, name: History.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HistoryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
