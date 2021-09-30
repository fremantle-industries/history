defmodule History.Commander.StopPipeline do
  def execute(id) do
    History.Pipelines.stop(id)
  end
end
