defmodule HistoryWeb.PredictedFundingRateLive do
  use HistoryWeb, :live_view
  import HistoryWeb.JobView
  alias History.{PredictedFundingRates, PredictedFundingRateJobs}

  @latest_page 0
  @latest_page_size 5

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(History.PubSub, "predicted_funding_rate_job:*")

    predicted_funding_rates =
      PredictedFundingRates.search_latest(page: @latest_page, page_size: @latest_page_size)

    jobs = PredictedFundingRateJobs.latest(page: @latest_page, page_size: @latest_page_size)

    socket =
      socket
      |> assign(:predicted_funding_rates, predicted_funding_rates)
      |> assign(:job_schedules, [])
      |> assign(:jobs, jobs)

    {:ok, socket}
  end

  @impl true
  def handle_info({:predicted_funding_rate_job, :update, _}, socket) do
    jobs =
      PredictedFundingRateJobs.latest(
        page: @latest_page,
        page_size: @latest_page_size
      )

    socket =
      socket
      |> assign(:jobs, jobs)

    {:noreply, socket}
  end
end
