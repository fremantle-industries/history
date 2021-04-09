defmodule GhostWeb.ProductLive do
  use GhostWeb, :live_view
  alias Ghost.Products
  alias Ghost.Products.Product

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(query: nil)
      |> assign(:symbols, Products.symbols())
      |> assign(:products, Products.all())
      |> assign(:changeset, Product.changeset(%Product{}, %{}))

    {:ok, socket}
  end

  def handle_event("delete", %{"product-id" => id}, socket) do
    Products.delete(id)
    {:noreply, assign(socket, products: Products.all())}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, products: Products.search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case Products.search(query) do
      [] ->
        {:noreply,
         socket
         |> assign(products: [], query: query)}

      products ->
        {:noreply, assign(socket, products: products, query: query)}
    end
  end
end
