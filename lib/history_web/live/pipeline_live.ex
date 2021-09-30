defmodule HistoryWeb.PipelineLive do
  use HistoryWeb, :live_view
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign(query: nil)
      |> assign_node(params)
      |> assign_pipelines()

    {:noreply, socket}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    socket =
      socket
      |> assign(:query, query)
      |> assign_pipelines()

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    socket =
      socket
      |> assign(:query, query)
      |> assign_pipelines()

    {:noreply, socket}
  end

  @impl true
  def handle_event("start", %{"id" => id}, socket) do
    id
    |> String.to_atom()
    |> History.Commander.start_pipeline(node: String.to_atom(socket.assigns.node))

    socket =
      socket
      |> assign_pipelines()

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop", %{"id" => id}, socket) do
    id
    |> String.to_atom()
    |> History.Commander.stop_pipeline(node: String.to_atom(socket.assigns.node))

    socket =
      socket
      |> assign_pipelines()

    {:noreply, socket}
  end

  defp assign_pipelines(socket) do
    pipelines = History.Commander.pipelines(node: String.to_atom(socket.assigns.node))
    socket |> assign(:pipelines, pipelines)
  end
end
