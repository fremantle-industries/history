defmodule GhostWeb.StatusView do
  use GhostWeb, :view

  def render("_pill.html", assigns) do
    title = Map.get(assigns, :title, "status")

    ~E"""
    <span class="bg-<%= color(assigns.status) %>-50 text-<%= color(assigns.status) %>-400 py-2 px-4 inline-block rounded-full" title="<%= title %>">
      <%= assigns.status %>
    </span>
    """
  end

  defp color(:enqueued), do: "yellow"
  defp color(:error), do: "red"
  defp color(:working), do: "purple"
  defp color(:complete), do: "green"
end
