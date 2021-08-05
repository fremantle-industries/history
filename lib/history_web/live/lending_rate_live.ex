defmodule HistoryWeb.LendingRateLive do
  use HistoryWeb, :live_view
  import HistoryWeb.JobView
  alias History.{LendingRates, LendingRateHistoryJobs}

  @latest_page 0
  @latest_page_size 5

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(History.PubSub, "lending_rate_history_job:*")
    lending_rates = LendingRates.search_latest(page: @latest_page, page_size: @latest_page_size)
    jobs = LendingRateHistoryJobs.latest(page: @latest_page, page_size: @latest_page_size)

    socket =
      socket
      |> assign(:lending_rates, lending_rates)
      |> assign(:job_schedules, [])
      |> assign(:jobs, jobs)

    {:ok, socket}
  end

  @impl true
  def handle_info({:lending_rate_history_job, :update, _}, socket) do
    jobs =
      LendingRateHistoryJobs.latest(
        page: @latest_page,
        page_size: @latest_page_size
      )

    socket =
      socket
      |> assign(:jobs, jobs)

    {:noreply, socket}
  end
end
