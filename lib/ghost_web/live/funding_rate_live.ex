defmodule GhostWeb.FundingRateLive do
  use GhostWeb, :live_view
  import GhostWeb.FundingRateView
  alias Ghost.{FundingRates, FundingRateHistoryJobs}

  @latest_page 0
  @latest_page_size 5

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Ghost.PubSub, "funding_rate_history_job:*")
    funding_rates = FundingRates.search_latest(page: @latest_page, page_size: @latest_page_size)
    jobs = FundingRateHistoryJobs.latest(page: @latest_page, page_size: @latest_page_size)

    socket =
      socket
      |> assign(:funding_rates, funding_rates)
      |> assign(:job_schedules, [])
      |> assign(:jobs, jobs)

    {:ok, socket}
  end

  @impl true
  def handle_info({:funding_rate_history_job, :update, _}, socket) do
    jobs =
      FundingRateHistoryJobs.latest(
        page: @latest_page,
        page_size: @latest_page_size
      )

    socket =
      socket
      |> assign(:jobs, jobs)

    {:noreply, socket}
  end
end
