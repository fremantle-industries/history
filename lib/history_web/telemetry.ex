defmodule HistoryWeb.Telemetry do
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
        tags: [:method, :request_path],
        tag_values: &tag_method_and_request_path/1,
        unit: {:native, :millisecond}
      ),
      last_value("phoenix.router_dispatch.stop.duration",
        tags: [:controller_action],
        tag_values: &tag_controller_action/1,
        unit: {:native, :millisecond}
      ),

      # Database Metrics
      last_value("history.repo.query.total_time", unit: {:native, :millisecond}),
      last_value("history.repo.query.decode_time", unit: {:native, :millisecond}),
      last_value("history.repo.query.query_time", unit: {:native, :millisecond}),
      last_value("history.repo.query.queue_time", unit: {:native, :millisecond}),
      last_value("history.repo.query.idle_time", unit: {:native, :millisecond}),

      # Broadway Metrics
      last_value("broadway.processor.message.stop.duration",
        tags: [:name, :index],
        unit: {:native, :millisecond}
      ),
      # TODO: Figure out how to get last value + counter. Currently can only be one or the other
      # counter("broadway.processor.message.stop.duration",
      #   tags: [:name, :index],
      #   unit: {:native, :millisecond}
      # ),
      counter("broadway.processor.message.exception.duration",
        tags: [:name, :index],
        unit: {:native, :millisecond}
      ),
    ]
  end

  defp prometheus_metrics_name do
    Application.get_env(:history, :prometheus_metrics_name, :history_prometheus_metrics)
  end

  defp prometheus_metrics_port do
    Application.get_env(:history, :prometheus_metrics_port, 9569)
  end

  # Extracts labels like "GET /"
  defp tag_method_and_request_path(metadata) do
    Map.take(metadata.conn, [:method, :request_path])
  end

  # Extracts controller#action from route dispatch
  defp tag_controller_action(%{plug: plug, plug_opts: plug_opts}) when is_atom(plug_opts) do
    %{controller_action: "#{inspect(plug)}##{plug_opts}"}
  end

  defp tag_controller_action(%{plug: plug}) do
    %{controller_action: inspect(plug)}
  end
end
