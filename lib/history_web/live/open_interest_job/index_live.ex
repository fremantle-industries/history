defmodule HistoryWeb.OpenInterestJob.IndexLive do
  use HistoryWeb, :live_view
  # import HistoryWeb.JobView
  alias History.{OpenInterests, OpenInterestHistoryJobs, Tokens}

  @impl true
  def mount(_params, _session, socket) do
    OpenInterestHistoryJobs.subscribe_by_id("*")

    socket =
      socket
      |> assign_tokens()
      |> assign(:job_changeset, OpenInterestHistoryJobs.job_changeset(%{}))

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
      |> assign_latest()

    {:noreply, socket}
  end

  @impl true
  def handle_event("download", params, socket) do
    job_params = Map.get(params, "job", %{})

    tokens =
      job_params
      |> Map.get("tokens", [])
      |> Enum.map(&Jason.decode!/1)

    params =
      job_params
      |> Map.put("tokens", tokens)
      |> Map.put("status", "enqueued")

    socket =
      with {:ok, job} <- OpenInterestHistoryJobs.insert(params) do
        socket
        |> assign(
          :job_changeset,
          OpenInterests.OpenInterestHistoryJob.changeset(job, %{})
        )
        |> assign_latest()
      else
        {:error, changeset} ->
          socket
          |> assign(:job_changeset, changeset)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel", %{"job-id" => job_id}, socket) do
    job = OpenInterestHistoryJobs.get!(job_id)
    {:ok, _} = OpenInterestHistoryJobs.cancel(job)

    socket =
      socket
      |> assign_latest()

    {:noreply, socket}
  end

  @impl true
  def handle_info({"open_interest_history_job:*", _}, socket) do
    jobs =
      OpenInterestHistoryJobs.latest(
        page: socket.assigns.current_page,
        page_size: socket.assigns.page_size
      )

    socket =
      socket
      |> assign(:jobs, jobs)

    {:noreply, socket}
  end

  defp assign_latest(socket) do
    first_page = 1
    current_page = socket.assigns.current_page
    previous_page = max(current_page - 1, first_page)
    last_page = ceil(OpenInterestHistoryJobs.count() / socket.assigns.page_size)
    next_page = min(current_page + 1, last_page)

    socket
    |> assign(current_page: current_page)
    |> assign(first_page: first_page)
    |> assign(previous_page: previous_page)
    |> assign(last_page: last_page)
    |> assign(next_page: next_page)
    |> assign(
      :jobs,
      OpenInterestHistoryJobs.latest(
        page: socket.assigns.current_page,
        page_size: socket.assigns.page_size
      )
    )
  end

  defp assign_tokens(socket) do
    socket
    |> assign(:tokens, Tokens.search(nil))
  end
end
