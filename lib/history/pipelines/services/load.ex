defmodule History.Pipelines.Services.Load do
  alias History.Pipelines

  def call(config) do
    config
    |> Enum.map(fn {id, attrs} ->
      start_on_boot = get_attr(attrs, :start_on_boot, true)
      markets = get_attr(attrs, :markets, "*")
      streams = get_attr(attrs, :streams, [])
      steps = get_attr(attrs, :steps, [])

      pipeline = %Pipelines.PipelineConfig{
        id: id,
        start_on_boot: start_on_boot,
        markets: markets,
        streams: streams,
        steps: steps
      }

      {:ok, _} = Pipelines.PipelineConfigStore.put(pipeline)
    end)
  end

  def get_attr(attrs, :start_on_boot = key, default), do: Map.get(attrs, key, default)
  def get_attr(attrs, :markets = key, default), do: Map.get(attrs, key, default)
  def get_attr(attrs, :streams = key, default), do: Map.get(attrs, key, default)
  def get_attr(attrs, :steps = key, default), do: Map.get(attrs, key, default)
end
