defmodule HistoryWeb.OpenInterestLive do
  use HistoryWeb, :live_view
  alias History.OpenInterestHistoryJobs

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Tai.PubSub, "open_interest_history_job:*")

    socket =
      socket
      |> assign_job_schedules()
      |> assign_latest_jobs()

    {:ok, socket}
  end

  @impl true
  def handle_info({:open_interest_history_job, :update, _}, socket) do
    socket =
      socket
      |> assign_latest_jobs()

    {:noreply, socket}
  end

  defp assign_job_schedules(socket) do
    socket
    |> assign(:job_schedules, [])
  end

  @latest_page 0
  @latest_page_size 5

  defp assign_latest_jobs(socket) do
    jobs =
      OpenInterestHistoryJobs.latest(
        page: @latest_page,
        page_size: @latest_page_size
      )

    socket
    |> assign(:jobs, jobs)
  end
end
