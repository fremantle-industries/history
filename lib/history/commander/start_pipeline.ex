defmodule History.Commander.StartPipeline do
  def execute(id) do
    History.Pipelines.start(id)
  end
end
