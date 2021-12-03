defmodule HistoryWeb.LendingRateJob.ShowLive do
  use HistoryWeb, :live_view
  alias History.{LendingRateHistoryJobs, LendingRateHistoryChunks}

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    Phoenix.PubSub.subscribe(Tai.PubSub, "lending_rate_history_job:*")
    Phoenix.PubSub.subscribe(Tai.PubSub, "lending_rate_history_chunk:*")

    socket =
      socket
      |> assign(job: LendingRateHistoryJobs.get!(id))
      |> assign_chunk_status_totals()

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
  def handle_info({:lending_rate_history_job, :update, _}, socket) do
    socket =
      socket
      |> assign(job: LendingRateHistoryJobs.get!(socket.assigns.job.id))
      |> assign_chunk_status_totals()
      |> assign_chunks()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:lending_rate_history_chunk, :update, _}, socket) do
    socket =
      socket
      |> assign_chunk_status_totals()
      |> assign_chunks()

    {:noreply, socket}
  end

  defp assign_chunks(socket) do
    job = socket.assigns.job
    first_page = 1
    current_page = socket.assigns.current_page
    previous_page = max(current_page - 1, first_page)
    last_page = ceil(socket.assigns.total_chunks / socket.assigns.page_size)
    next_page = min(current_page + 1, last_page)

    socket
    |> assign(current_page: current_page)
    |> assign(first_page: first_page)
    |> assign(previous_page: previous_page)
    |> assign(last_page: last_page)
    |> assign(next_page: next_page)
    |> assign(
      :chunks,
      LendingRateHistoryChunks.by_job(job.id,
        page: current_page,
        page_size: socket.assigns.page_size
      )
    )
  end

  @status_colors [enqueued: "yellow", working: "purple", complete: "green", error: "red"]
  defp assign_chunk_status_totals(socket) do
    job = socket.assigns.job

    @status_colors
    |> Enum.reduce(
      socket,
      fn {status, _color}, socket ->
        total = LendingRateHistoryChunks.count_by_job_id_and_status(job.id, status)
        assign(socket, :"total_#{status}", total)
      end
    )
    |> assign(total_chunks: LendingRateHistoryChunks.count_by_job_id(job.id))
  end
end
