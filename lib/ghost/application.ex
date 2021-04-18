defmodule Ghost.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Ghost.Repo,
      GhostWeb.Telemetry,
      {Phoenix.PubSub, name: Ghost.PubSub},
      GhostWeb.Endpoint,
      Ghost.FundingRateHistoryJobs.Supervisor,
      Ghost.LendingRateHistoryJobs.Supervisor
    ]

    opts = [strategy: :one_for_one, name: Ghost.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GhostWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
