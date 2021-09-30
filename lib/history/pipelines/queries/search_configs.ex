defmodule History.Pipelines.Queries.SearchConfigs do
  alias History.Pipelines

  def call(_query) do
    Pipelines.PipelineConfigStore.all()
  end
end
