defmodule GhostWeb.BasisFutureLive do
  use GhostWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket =
      socket
      |> assign(:current_page, 1)
      |> assign(:last_page, 1)
      |> assign(:futures_basis, futures_basis())

    {:noreply, socket}
  end

  defp futures_basis do
    Ghost.Basis.futures()
    |> Enumerati.order([:spot_product, :spot_venue, :future_product, :future_venue])
  end

  defp to_chart(future_basis) do
    spot_venue = future_basis.spot_venue |> String.upcase()
    spot_product = future_basis.spot_product |> String.upcase()
    future_venue = future_basis.future_venue |> String.upcase()
    future_product = future_basis.future_product |> String.upcase()

    "https://www.tradingview.com/chart/?symbol=(#{future_venue}:#{future_product}-#{spot_venue}:#{spot_product})/#{spot_venue}:#{spot_product}*100&interval=4H"
  end
end
