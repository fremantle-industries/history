defmodule GhostWeb.FundingLive do
  use GhostWeb, :live_view
  require Ecto.Query

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
