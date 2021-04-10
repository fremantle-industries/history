defmodule GhostWeb.FundingRateLatestLive do
  use GhostWeb, :live_view
  alias Ghost.FundingRates
  alias Ghost.FundingRates.FundingRate

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:changeset, FundingRate.changeset(%FundingRate{}, %{}))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    query = Map.get(params, "query")
    {page, _} = params |> Map.get("page", "1") |> Integer.parse()
    {page_size, _} = params |> Map.get("page_size", "25") |> Integer.parse()

    socket =
      socket
      |> assign(page_size: page_size)
      |> assign(current_page: page)
      |> assign_search(query)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"funding-rate-id" => id}, socket) do
    FundingRates.delete(id)

    socket =
      socket
      |> assign_search(socket.assigns.query)

    {:noreply, socket}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    socket =
      socket
      |> assign_search(query)

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    socket =
      socket
      |> assign_search(query)

    {:noreply, socket}
  end

  defp assign_search(socket, query) do
    first_page = 1
    current_page = socket.assigns.current_page
    previous_page = max(current_page - 1, first_page)
    last_page = ceil(FundingRates.count(query: query) / socket.assigns.page_size)
    next_page = min(current_page + 1, last_page)

    socket
    |> assign(:query, query)
    |> assign(current_page: current_page)
    |> assign(first_page: first_page)
    |> assign(previous_page: previous_page)
    |> assign(last_page: last_page)
    |> assign(next_page: next_page)
    |> assign(
      :funding_rates,
      FundingRates.search_latest(
        query: query,
        page: socket.assigns.current_page,
        page_size: socket.assigns.page_size
      )
    )
  end
end
