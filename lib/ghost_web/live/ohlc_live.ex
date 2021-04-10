defmodule GhostWeb.OHLCLive do
  use GhostWeb, :live_view
  require Ecto.Query

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:ohlc, sorted_ohlc())
      |> assign(:changeset, Ghost.OHLC.changeset(%Ghost.OHLC{}, %{}))
      |> assign(:schedules, [])

    {:ok, socket}
  end

  @seconds_in_hour 60 * 60

  @impl true
  def handle_event("hour-start", _, socket) do
    today = Date.utc_today()
    now = Time.utc_now()
    {:ok, current_hour} = Time.new(now.hour, 0, 0)
    next_hour = current_hour |> Time.add(@seconds_in_hour)
    {:ok, end_at_hour} = DateTime.new(today, next_hour)
    changeset = Ecto.Changeset.put_change(socket.assigns.changeset, :time, end_at_hour)
    Ghost.Repo.insert(changeset)

    socket =
      socket
      |> assign(:ohlc, sorted_ohlc())
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event("today", _, socket) do
    open_at_today = Timex.today() |> Timex.to_datetime()
    changeset = Ecto.Changeset.put_change(socket.assigns.changeset, :time, open_at_today)
    Ghost.Repo.insert(changeset)

    socket =
      socket
      |> assign(:ohlc, sorted_ohlc())
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event("tomorrow", _params, socket) do
    open_at_tomorrow = Timex.today() |> Timex.to_datetime() |> Timex.shift(days: 1)
    changeset = Ecto.Changeset.put_change(socket.assigns.changeset, :time, open_at_tomorrow)
    Ghost.Repo.insert(changeset)

    socket =
      socket
      |> assign(:ohlc, sorted_ohlc())
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event("copy", %{"ohlc-id" => ohlc_id}, socket) do
    id = ohlc_id |> String.to_integer()
    candle = Ghost.Repo.get(Ghost.OHLC, id)
    changeset = Ghost.OHLC.changeset(candle, %{})

    socket =
      socket
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"ohlc" => ohlc_params}, socket) do
    changeset = Ghost.OHLC.changeset(%Ghost.OHLC{}, ohlc_params)

    socket =
      with {:ok, _} <- Ghost.Repo.insert(changeset) do
        socket
        |> assign(:ohlc, sorted_ohlc())
        |> assign(:changeset, changeset)
      else
        {:error, changeset} ->
          socket
          |> assign(:changeset, changeset)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"ohlc-id" => ohlc_id}, socket) do
    id = ohlc_id |> String.to_integer()
    %Ghost.OHLC{id: id} |> Ghost.Repo.delete()

    socket =
      socket
      |> assign(:ohlc, sorted_ohlc())

    {:noreply, socket}
  end

  defp sorted_ohlc do
    Ecto.Query.from(
      b in "ohlc",
      order_by: [desc: :time],
      select: [:id, :period, :time, :base, :quote, :open, :high, :low, :close, :volume, :source]
    )
    |> Ghost.Repo.all()
  end
end
