defmodule GhostWeb.FundingRateLive do
  use GhostWeb, :live_view
  alias Ghost.{FundingRates, FundingRateHistoryDownloads, Products}
  alias Ghost.FundingRates.FundingRate
  alias Ghost.FundingRateHistoryDownloads.FundingRateHistoryDownload

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(query: nil)
      |> assign(:funding_rates, FundingRates.all())
      |> assign(:changeset, FundingRate.changeset(%FundingRate{}, %{}))
      |> assign(:history_downloads, FundingRateHistoryDownloads.all())
      |> assign(:history_download_changeset, FundingRateHistoryDownloads.changeset_today(%{}))
      |> assign(:swap_products, swap_products())

    {:ok, socket}
  end

  @impl true
  def handle_event("delete", %{"funding-rate-id" => id}, socket) do
    FundingRates.delete(id)
    {:noreply, assign(socket, funding_rates: FundingRates.all())}
  end

  @impl true
  def handle_event("download", %{"funding_rate_history_download" => params}, socket) do
    products =
      params
      |> Map.get("products", [])
      |> Enum.map(&Jason.decode!/1)

    params = Map.put(params, "products", products)
    changeset = FundingRateHistoryDownload.changeset(%FundingRateHistoryDownload{}, params)

    socket =
      with {:ok, history_download} <- FundingRateHistoryDownloads.insert(params) do
        socket
        |> assign(:history_downloads, FundingRateHistoryDownloads.all())
        |> assign(
          :history_download_changeset,
          FundingRateHistoryDownload.changeset(history_download, %{})
        )
      else
        {:error, changeset} ->
          socket
          |> assign(:history_download_changeset, changeset)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel", %{"history-download-id" => id}, socket) do
    require Logger
    Logger.warn("TODO... cancel history download: #{id}")
    {:noreply, socket}
  end

  defp swap_products do
    Products.swap()
    |> Enum.map(fn p ->
      [
        value: %{symbol: p.symbol, venue: p.venue} |> Jason.encode!(),
        key: "#{p.venue}:#{p.symbol}"
      ]
    end)
  end

  defp from(%FundingRateHistoryDownload{} = history_download) do
    DateTime.new!(history_download.from_date, history_download.from_time)
  end

  defp to(%FundingRateHistoryDownload{} = history_download) do
    DateTime.new!(history_download.to_date, history_download.to_time)
  end

  defp format_download_products(products) do
    products
    |> Enum.map(&"#{&1.venue}:#{&1.symbol}")
    |> Enum.join(", ")
  end
end
