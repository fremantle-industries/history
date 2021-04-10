defmodule GhostWeb.FundingRateJob.ShowLive do
  use GhostWeb, :live_view
  alias Ghost.{FundingRateHistoryJobs, FundingRateHistoryChunks}

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    Phoenix.PubSub.subscribe(Ghost.PubSub, "funding_rate_history_job:*")
    Phoenix.PubSub.subscribe(Ghost.PubSub, "funding_rate_history_chunk:*")

    socket =
      socket
      |> assign(job: FundingRateHistoryJobs.get!(id))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {page, _} = params |> Map.get("page", "1") |> Integer.parse()
    {page_size, _} = params |> Map.get("page_size", "25") |> Integer.parse()

    socket =
      socket
      |> assign(page_size: page_size)
      |> assign(current_page: page)
      |> assign_chunks()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:funding_rate_history_job, :update, _}, socket) do
    socket =
      socket
      |> assign(job: FundingRateHistoryJobs.get!(socket.assigns.job.id))
      |> assign_chunks()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:funding_rate_history_chunk, :update, _}, socket) do
    socket =
      socket
      |> assign_chunks()

    {:noreply, socket}
  end

  defp assign_chunks(socket) do
    job = socket.assigns.job
    first_page = 1
    current_page = socket.assigns.current_page
    previous_page = max(current_page - 1, first_page)
    last_page = ceil(FundingRateHistoryChunks.count(job.id) / socket.assigns.page_size)
    next_page = min(current_page + 1, last_page)

    socket
    |> assign(current_page: current_page)
    |> assign(first_page: first_page)
    |> assign(previous_page: previous_page)
    |> assign(last_page: last_page)
    |> assign(next_page: next_page)
    |> assign(
      :chunks,
      FundingRateHistoryChunks.by_job(job.id,
        page: current_page,
        page_size: socket.assigns.page_size
      )
    )
  end
end
