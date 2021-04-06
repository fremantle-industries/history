defmodule GhostWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {TelemetryMetricsPrometheus,
       [
         metrics: metrics(),
         port: prometheus_metrics_port(),
         name: prometheus_metrics_name(),
         options: [ref: :"TelemetryMetricsPrometheus.Router.HTTP_#{prometheus_metrics_port()}"]
       ]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix Metrics
      last_value("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      last_value("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),

      # Database Metrics
      last_value("ghost.repo.query.total_time", unit: {:native, :millisecond}),
      last_value("ghost.repo.query.decode_time", unit: {:native, :millisecond}),
      last_value("ghost.repo.query.query_time", unit: {:native, :millisecond}),
      last_value("ghost.repo.query.queue_time", unit: {:native, :millisecond}),
      last_value("ghost.repo.query.idle_time", unit: {:native, :millisecond})
    ]
  end

  defp prometheus_metrics_name do
    Application.get_env(:ghost, :prometheus_metrics_name, :ghost_prometheus_metrics)
  end

  defp prometheus_metrics_port do
    Application.get_env(:ghost, :prometheus_metrics_port, 9569)
  end
end
