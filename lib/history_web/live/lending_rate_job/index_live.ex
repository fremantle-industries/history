defmodule HistoryWeb.LendingRateJob.IndexLive do
  use HistoryWeb, :live_view
  import HistoryWeb.JobView
  alias History.{LendingRateHistoryJobs, LendingRates, Tokens}

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Tai.PubSub, "lending_rate_history_job:*")

    socket =
      socket
      |> assign(:tokens, venue_tokens())
      |> assign(:job_changeset, LendingRateHistoryJobs.job_changeset_today(%{}))

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
  def handle_event("download", %{"lending_rate_history_job" => params}, socket) do
    tokens =
      params
      |> Map.get("tokens", [])
      |> Enum.map(&Jason.decode!/1)

    params =
      params
      |> Map.put("tokens", tokens)
      |> Map.put("status", "enqueued")

    socket =
      with {:ok, job} <- LendingRateHistoryJobs.insert(params) do
        socket
        |> assign(
          :job_changeset,
          LendingRates.LendingRateHistoryJob.changeset(job, %{})
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
  def handle_event("cancel", %{"history-job-id" => id}, socket) do
    require Logger
    Logger.warn("TODO... cancel history download job: #{id}")
    {:noreply, socket}
  end

  @impl true
  def handle_info({:lending_rate_history_job, :update, _}, socket) do
    jobs =
      LendingRateHistoryJobs.latest(
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
    last_page = ceil(LendingRateHistoryJobs.count() / socket.assigns.page_size)
    next_page = min(current_page + 1, last_page)

    socket
    |> assign(current_page: current_page)
    |> assign(first_page: first_page)
    |> assign(previous_page: previous_page)
    |> assign(last_page: last_page)
    |> assign(next_page: next_page)
    |> assign(
      :jobs,
      LendingRateHistoryJobs.latest(
        page: socket.assigns.current_page,
        page_size: socket.assigns.page_size
      )
    )
  end

  defp venue_tokens do
    Tokens.venue_tokens()
    |> Enum.map(fn {venue, base} ->
      [
        value: %{symbol: base, venue: venue} |> Jason.encode!(),
        key: "#{venue}:#{base}"
      ]
    end)
  end
end
