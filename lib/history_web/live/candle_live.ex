defmodule HistoryWeb.CandleLive do
  use HistoryWeb, :live_view
  import HistoryWeb.JobView
  alias History.{Candles, CandleHistoryJobs, Page}

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Tai.PubSub, "candle_history_job:*")

    socket =
      socket
      |> assign_job_schedules()
      |> assign_latest_jobs()

    {:ok, socket}
  end

  @impl true
  def handle_info({:candle_history_job, :update, _}, socket) do
    socket =
      socket
      |> assign_latest_jobs()

    {:noreply, socket}
  end

  defp assign_job_schedules(socket) do
    socket
    |> assign(:job_schedules, [])
  end

  defp assign_latest_jobs(socket) do
    jobs =
      CandleHistoryJobs.latest(
        page: Page.default_page_number(),
        page_size: Page.small_page_size()
      )

    socket
    |> assign(:jobs, jobs)
  end
end
