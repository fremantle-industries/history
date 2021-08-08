defmodule HistoryWeb.TradeJob.IndexLive do
  use HistoryWeb, :live_view
  import HistoryWeb.JobView
  alias History.{Products, Trades, TradeHistoryJobs}

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Tai.PubSub, "trade_history_job:*")

    socket =
      socket
      |> assign(:query, nil)
      |> assign_products()
      |> assign(:job_changeset, TradeHistoryJobs.job_changeset_today(%{}))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {page, _} = params |> Map.get("page", "1") |> Integer.parse()
    {page_size, _} = params |> Map.get("page_size", "25") |> Integer.parse()

    socket =
      socket
      |> assign(:page_size, page_size)
      |> assign(:current_page, page)
      |> assign_latest()

    {:noreply, socket}
  end

  @impl true
  def handle_event("download", %{"trade_history_job" => params}, socket) do
    products =
      params
      |> Map.get("products", [])
      |> Enum.map(&Jason.decode!/1)

    params =
      params
      |> Map.put("products", products)
      |> Map.put("status", "enqueued")

    socket =
      with {:ok, job} <- TradeHistoryJobs.insert(params) do
        socket
        |> assign(
          :job_changeset,
          Trades.TradeHistoryJob.changeset(job, %{})
        )
        |> assign_latest()
      else
        {:error, changeset} ->
          socket
          |> assign(:job_changeset, changeset)
      end

    {:noreply, socket}
  end

  # @impl true
  # def handle_event("cancel", %{"job-id" => job_id}, socket) do
  #   job = FundingRateHistoryJobs.get!(job_id)
  #   {:ok, _} = FundingRateHistoryJobs.cancel(job)

  #   socket =
  #     socket
  #     |> assign_latest()

  #   {:noreply, socket}
  # end

  @impl true
  def handle_info({:trade_history_job, :update, _}, socket) do
    jobs =
      TradeHistoryJobs.latest(
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
    last_page = ceil(TradeHistoryJobs.count() / socket.assigns.page_size)
    next_page = min(current_page + 1, last_page)

    socket
    |> assign(current_page: current_page)
    |> assign(first_page: first_page)
    |> assign(previous_page: previous_page)
    |> assign(last_page: last_page)
    |> assign(next_page: next_page)
    |> assign(
      :jobs,
      TradeHistoryJobs.latest(
        page: socket.assigns.current_page,
        page_size: socket.assigns.page_size
      )
    )
  end

  defp assign_products(socket) do
    products = Products.search(nil)

    socket
    |> assign(:products, products)
  end
end
