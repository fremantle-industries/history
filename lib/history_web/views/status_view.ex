defmodule HistoryWeb.StatusView do
  use HistoryWeb, :view

  def render("_pill.html", assigns) do
    title = Map.get(assigns, :title, "status")

    ~H"""
    <span class={"#{bg_color(assigns.status)} #{text_color(assigns.status)} py-2 px-4 inline-block rounded-full"} title={title}}>
      <%= assigns.status %>
    </span>
    """
  end

  def render("_progress.html", assigns) do
    finished = assigns.complete + assigns.error
    progress_pct = finished / assigns.total * 100
    formatted_progress_pct = :io_lib.format("~.2f", [progress_pct])
    title = "enqueued=#{assigns.enqueued}, working=#{assigns.working}, complete=#{assigns.complete}, error=#{assigns.error}"

    ~H"""
    <span title={title}>
      <strong>progress=</strong><%= formatted_progress_pct %>%
    </span>
    """
  end

  defp bg_color(:enqueued), do: "bg-yellow-50"
  defp bg_color(:error), do: "bg-red-50"
  defp bg_color(:working), do: "bg-purple-50"
  defp bg_color(:not_found), do: "bg-gray-50"
  defp bg_color(:complete), do: "bg-green-50"
  defp bg_color(:canceled), do: "bg-gray-400"

  defp text_color(:enqueued), do: "text-yellow-400"
  defp text_color(:error), do: "text-red-400"
  defp text_color(:working), do: "text-purple-400"
  defp text_color(:not_found), do: "text-gray-400"
  defp text_color(:complete), do: "text-green-400"
  defp text_color(:canceled), do: "text-white"
end
