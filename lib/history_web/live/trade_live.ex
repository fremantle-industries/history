defmodule HistoryWeb.TradeLive do
  use HistoryWeb, :live_view
  import HistoryWeb.JobView
  alias History.{Trades, TradeHistoryJobs}

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_latest_trades()
      |> assign_job_schedules()
      |> assign_latest_jobs()

    {:ok, socket}
  end

  @latest_page 0
  @latest_page_size 5

  defp assign_latest_trades(socket) do
    latest_trades =
      Trades.search_latest(
        page: @latest_page,
        page_size: @latest_page_size
      )

    socket
    |> assign(:trades, latest_trades)
  end

  defp assign_job_schedules(socket) do
    socket
    |> assign(:job_schedules, [])
  end

  defp assign_latest_jobs(socket) do
    jobs =
      TradeHistoryJobs.latest(
        page: @latest_page,
        page_size: @latest_page_size
      )

    socket
    |> assign(:jobs, jobs)
  end
end
