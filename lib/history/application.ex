defmodule History.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      History.Repo,
      History.EtsRepo,
      HistoryWeb.Telemetry,
      {Phoenix.PubSub, name: History.PubSub},
      HistoryWeb.Endpoint,
      History.Trades.Supervisor,
      History.FundingRates.Supervisor,
      History.PredictedFundingRates.Supervisor,
      History.LendingRates.Supervisor
    ]

    opts = [strategy: :one_for_one, name: History.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_phase(:basis, _start_type, _phase_args) do
    History.Basis.hydrate()
    :ok
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HistoryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
