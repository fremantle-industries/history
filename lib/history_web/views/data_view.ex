defmodule HistoryWeb.DataView do
  use HistoryWeb, :view
  import Phoenix.HTML.Link

  def render("_breadcrumbs.html", assigns) do
    indexed_sections = assigns.section |> List.wrap() |> Enum.with_index()

    ~E"""
    <h2 class="text-3xl">
      <%= Enum.map(indexed_sections, &render_breadcrumb_section/1) %>
    </h2>
    """
  end

  def render("_header.html", assigns) do
    sections = ["Data" | assigns.section]
    assigns = Map.put(assigns, :section, sections)
    render("_breadcrumbs.html", assigns)
  end

  def render("_nav.html", assigns) do
    ~E"""
    <nav class="mt-2 space-x-1">
      <%= link "Trades", to: Routes.trade_path(assigns.conn, :index), class: "hover:opacity-75" %>
      <span class="text-gray-400">|</span>
      <%= link "Funding Rates", to: Routes.funding_rate_path(assigns.conn, :index), class: "hover:opacity-75" %>
      <span class="text-gray-400">|</span>
      <%= link "Predicted Funding Rates", to: Routes.predicted_funding_rate_path(assigns.conn, :index), class: "hover:opacity-75" %>
      <span class="text-gray-400">|</span>
      <%= link "Lending Rates", to: Routes.lending_rate_path(assigns.conn, :index), class: "hover:opacity-75" %>
    </nav>
    """
  end

  defp render_breadcrumb_section({{section, to}, index}) do
    text = if index > 0, do: "/#{section}", else: section
    link(text, to: to, class: "opacity-70 hover:opacity-50")
  end

  defp render_breadcrumb_section({section, index}) when index > 0, do: "/#{section}"
  defp render_breadcrumb_section({section, _}), do: section
end
