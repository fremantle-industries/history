defmodule HistoryWeb.FundingRateLive do
  use HistoryWeb, :live_view
  import HistoryWeb.JobView
  alias History.{FundingRates, FundingRateHistoryJobs}

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Tai.PubSub, "funding_rate_history_job:*")

    socket =
      socket
      |> assign_latest_funding_rates()
      |> assign_job_schedules()
      |> assign_latest_jobs()

    {:ok, socket}
  end

  @impl true
  def handle_info({:funding_rate_history_job, :update, _}, socket) do
    socket =
      socket
      |> assign_latest_jobs()

    {:noreply, socket}
  end

  @latest_page 0
  @latest_page_size 5

  defp assign_latest_funding_rates(socket) do
    funding_rates = FundingRates.search_latest(page: @latest_page, page_size: @latest_page_size)

    socket
    |> assign(:funding_rates, funding_rates)
  end

  defp assign_job_schedules(socket) do
    socket
    |> assign(:job_schedules, [])
  end

  defp assign_latest_jobs(socket) do
    jobs =
      FundingRateHistoryJobs.latest(
        page: @latest_page,
        page_size: @latest_page_size
      )

    socket
    |> assign(:jobs, jobs)
  end
end
