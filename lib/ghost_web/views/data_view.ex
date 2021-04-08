defmodule GhostWeb.DataView do
  use GhostWeb, :view

  def render("_header.html", assigns) do
    ~E"""
    <h2 class="text-3xl">
      <%= link "Data/", to: Routes.data_path(assigns.conn, :index), class: "opacity-70 hover:opacity-50" %><%= assigns.section %>
    </h2>
    """
  end

  def render("_nav.html", assigns) do
    ~E"""
    <nav class="mt-2 space-x-1">
      <%= link "OHLC", to: Routes.ohlc_path(assigns.conn, :index), class: "hover:opacity-75" %>
      <span class="text-gray-400">|</span>
      <%= link "Funding Rates", to: Routes.funding_path(assigns.conn, :index), class: "hover:opacity-75" %>
    </nav>
    """
  end
end
