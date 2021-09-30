defmodule History.Pipelines.Pipeline do
  use GenServer
  alias History.Pipelines

  defmodule State do
    @enforce_keys ~w[id streams steps]a
    defstruct ~w[id streams steps]a
  end

  @type pipeline_id :: Pipelines.PipelineConfig.id()
  @type pipeline_config :: Pipelines.PipelineConfig.t()

  @spec start_link(pipeline_config) :: GenServer.on_start()
  def start_link(config) do
    state = %State{id: config.id, streams: config.streams, steps: config.steps}
    name = process_name(config.id)

    GenServer.start_link(__MODULE__, state, name: name)
  end

  @spec process_name(pipeline_id) :: atom
  def process_name(id) do
    :"#{__MODULE__}_#{id}"
  end

  @impl true
  def init(state) do
    {:ok, state, {:continue, :subscribe}}
  end

  @impl true
  def handle_continue(:subscribe, state) do
    state.streams
    |> Enum.map(fn
      segments when is_list(segments) -> segments |> Enum.join(":")
      s -> s
    end)
    |> Enum.each(fn s ->
      subscribe(s)
    end)

    {:noreply, state}
  end

  @impl true
  def handle_info({"candle_history_chunk:period:" <> _, %{id: chunk_id, status: :complete} = source_msg}, state) do
    state.steps
    |> Enum.each(fn
      {mod, fun, args} ->
        apply(mod, fun, [[chunk_id: chunk_id] ++ args])
    end)

    broadcast(state.id, source_msg)

    {:noreply, state}
  end

  @impl true
  def handle_info({"pipeline:" <> pipeline_id, {:steps_complete, _} = source_msg}, state) do
    state.steps
    |> Enum.each(fn
      {mod, fun, args} ->
        apply(mod, fun, [[pipeline_id: pipeline_id] ++ args])
    end)

    broadcast(state.id, source_msg)

    {:noreply, state}
  end

  @impl true
  def handle_info({_, _}, state) do
    {:noreply, state}
  end

  defp subscribe(topic) do
    Pipelines.subscribe("#{topic}:*")
  end

  defp broadcast(id, source_msg) do
    topic = "pipeline:#{id}"
    msg = {:steps_complete, source_msg}
    Pipelines.broadcast(topic, msg)
  end
end
