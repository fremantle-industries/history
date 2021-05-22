defmodule GhostWeb.BasisSwapLive do
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
      |> assign(:swap_basis, swap_basis())

    {:noreply, socket}
  end

  defp swap_basis do
    Ghost.Basis.swap()
    |> Enumerati.order([:spot_product, :spot_venue, :swap_product, :swap_venue])
  end

  defp to_chart(swap_basis) do
    spot_venue = swap_basis.spot_venue |> String.upcase()
    spot_product = swap_basis.spot_product |> String.upcase()
    swap_venue = swap_basis.swap_venue |> String.upcase()
    swap_product = swap_basis.swap_product |> String.upcase()

    "https://www.tradingview.com/chart/?symbol=(#{swap_venue}:#{swap_product}-#{spot_venue}:#{spot_product})/#{spot_venue}:#{spot_product}*100&interval=4H"
  end
end
