defmodule History.Application do
  @moduledoc false
  require Logger

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
      History.LendingRates.Supervisor
    ]

    opts = [strategy: :one_for_one, name: History.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_phase(:load_job_schedules, _start_type, _phase_args) do
    {:ok, loaded_job_schedules} = History.JobSchedules.load()
    Logger.info "loaded job_schedules=#{loaded_job_schedules}"
    :ok
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HistoryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
