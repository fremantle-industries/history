defmodule HistoryWeb.ProductLive do
  use HistoryWeb, :live_view
  alias History.Products

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(query: nil)
      |> assign_symbols()
      |> assign_products()

    {:ok, socket}
  end

  @impl true
  def handle_event("delete", %{"product-id" => id}, socket) do
    Products.delete(id)

    socket =
      socket
      |> assign_products()

    {:noreply, socket}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    socket =
      socket
      |> assign(:query, query)
      |> assign_products()

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    socket =
      socket
      |> assign(:query, query)
      |> assign_products()

    {:noreply, socket}
  end

  @impl true
  def handle_event("import", _, socket) do
    Products.import()

    socket =
      socket
      |> assign_symbols()
      |> assign_products()

    {:noreply, socket}
  end

  defp assign_symbols(socket) do
    socket
    |> assign(:symbols, Products.symbols())
  end

  defp assign_products(socket) do
    socket
    |> assign(:products, Products.search(socket.assigns.query))
  end
end
