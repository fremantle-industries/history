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
      History.FundingRates.Supervisor,
      History.PredictedFundingRates.Supervisor,
      History.LendingRates.Supervisor,
      History.Pipelines.Supervisor,
      History.Commander
    ]

    opts = [strategy: :one_for_one, name: History.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_phase(:pipelines, _start_type, _phase_args) do
    # TODO: Do something with the return value
    History.Pipelines.load()
    # TODO: Should this be contained in the context?
    nil
    |> History.Pipelines.search_configs()
    |> Enumerati.filter(start_on_boot: true)
    |> Enum.each(fn c -> History.Pipelines.start(c.id) end)

    :ok
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HistoryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
