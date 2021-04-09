defmodule GhostWeb.LendingRateLive do
  use GhostWeb, :live_view
  alias Ghost.{LendingRates, LendingRateHistoryDownloads, Products}
  alias Ghost.LendingRates.LendingRate
  alias Ghost.LendingRateHistoryDownloads.LendingRateHistoryDownload

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(query: nil)
      |> assign(:lending_rates, LendingRates.all())
      |> assign(:changeset, LendingRate.changeset(%LendingRate{}, %{}))
      |> assign(:history_downloads, LendingRateHistoryDownloads.all())
      |> assign(:history_download_changeset, LendingRateHistoryDownloads.changeset_today(%{}))
      |> assign(:spot_products, spot_products())

    {:ok, socket}
  end

  @impl true
  def handle_event("delete", %{"lending-rate-id" => id}, socket) do
    LendingRates.delete(id)
    {:noreply, assign(socket, lending_rates: LendingRates.all())}
  end

  @impl true
  def handle_event("download", %{"lending_rate_history_download" => params}, socket) do
    products =
      params
      |> Map.get("products", [])
      |> Enum.map(&Jason.decode!/1)

    params = Map.put(params, "products", products)
    changeset = LendingRateHistoryDownload.changeset(%LendingRateHistoryDownload{}, params)

    socket =
      with {:ok, history_download} <- LendingRateHistoryDownloads.insert(params) do
        socket
        |> assign(:history_downloads, LendingRateHistoryDownloads.all())
        |> assign(
          :history_download_changeset,
          LendingRateHistoryDownload.changeset(history_download, %{})
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

  defp spot_products do
    Products.spot()
    |> Enum.map(fn p ->
      [
        value: %{symbol: p.symbol, venue: p.venue} |> Jason.encode!(),
        key: "#{p.venue}:#{p.symbol}"
      ]
    end)
  end

  defp from(%LendingRateHistoryDownload{} = history_download) do
    DateTime.new!(history_download.from_date, history_download.from_time)
  end

  defp to(%LendingRateHistoryDownload{} = history_download) do
    DateTime.new!(history_download.to_date, history_download.to_time)
  end

  defp format_download_products(products) do
    products
    |> Enum.map(&"#{&1.venue}:#{&1.symbol}")
    |> Enum.join(", ")
  end
end
