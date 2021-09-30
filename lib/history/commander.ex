defmodule History.Commander do
  use GenServer

  @spec start_link(term) :: GenServer.on_start()
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def pipelines(options \\ []) do
    options |> to_dest() |> GenServer.call(:pipelines)
  end

  def start_pipeline(id, options \\ []) do
    options |> to_dest() |> GenServer.call({:start_pipeline, id})
  end

  def stop_pipeline(id, options \\ []) do
    options |> to_dest() |> GenServer.call({:stop_pipeline, id})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:pipelines, _from, state) do
    {:reply, History.Commander.Pipelines.execute(), state}
  end

  @impl true
  def handle_call({:start_pipeline, id}, _from, state) do
    {:reply, History.Commander.StartPipeline.execute(id), state}
  end

  @impl true
  def handle_call({:stop_pipeline, id}, _from, state) do
    {:reply, History.Commander.StopPipeline.execute(id), state}
  end

  defp to_dest(options) do
    options
    |> Keyword.get(:node)
    |> case do
      nil -> __MODULE__
      node -> {__MODULE__, node}
    end
  end
end
