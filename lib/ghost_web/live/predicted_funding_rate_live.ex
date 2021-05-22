defmodule GhostWeb.PredictedFundingRateLive do
  use GhostWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
             |> assign(:predicted_funding_rates, [])

    {:ok, socket}
  end
end
