defmodule History.Commander.Pipelines do
  def execute do
    History.Pipelines.search_instances(nil)
  end
end
