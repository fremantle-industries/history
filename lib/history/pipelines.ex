defmodule History.Pipelines do
  alias History.Pipelines

  def load(config \\ Application.get_env(:history, :pipelines, %{})) do
    Pipelines.Services.Load.call(config)
  end

  def search_configs(query) do
    Pipelines.Queries.SearchConfigs.call(query)
  end

  def search_instances(query) do
    Pipelines.Queries.SearchInstances.call(query)
  end

  def get_config(id) do
    Pipelines.PipelineConfigStore.find(id)
  end

  def start(id) do
    case Pipelines.get_config(id) do
      {:ok, pipeline_config} ->
        Pipelines.InstanceSupervisor.start_pipeline(pipeline_config)

      {:error, _} = error ->
        error
    end
  end

  def stop(id) do
    id
    |> Pipelines.Instance.whereis()
    |> Pipelines.InstanceSupervisor.terminate_pipeline()
  end

  def broadcast(id, msg, pub_sub \\ Tai.PubSub) do
    [
      "pipeline:#{id}",
      "pipeline:*"
    ]
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(pub_sub, topic, {topic, msg})
    end)
  end

  def subscribe(topic, pub_sub \\ Tai.PubSub) do
    Phoenix.PubSub.subscribe(pub_sub, topic)
  end
end
