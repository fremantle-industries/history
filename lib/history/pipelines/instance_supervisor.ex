defmodule History.Pipelines.InstanceSupervisor do
  use DynamicSupervisor
  alias History.Pipelines

  @type pipeline_id :: Pipelines.PipelineConfig.id()
  @type pipeline_config :: Pipelines.PipelineConfig.t()

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec start_pipeline(pipeline_config) :: DynamicSupervisor.on_start_child()
  def start_pipeline(pipeline_config) do
    spec = %{
      id: pipeline_config.id,
      start: {Pipelines.Pipeline, :start_link, [pipeline_config]},
      type: :worker
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @spec terminate_pipeline(pid) :: :ok | {:error, :not_found}
  def terminate_pipeline(pid) when is_pid(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
