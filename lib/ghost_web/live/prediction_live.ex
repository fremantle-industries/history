defmodule GhostWeb.PredictionLive do
  use GhostWeb, :live_view
  require Ecto.Query

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:predictions, sorted_predictions())
      |> assign(:changeset, Ghost.Prediction.changeset(%Ghost.Prediction{}, %{}))

    {:ok, socket}
  end

  @seconds_in_hour 60 * 60

  @impl true
  def handle_event("end-at-hour", _, socket) do
    today = Date.utc_today()
    now = Time.utc_now()
    {:ok, current_hour} = Time.new(now.hour, 0, 0)
    next_hour = current_hour |> Time.add(@seconds_in_hour)
    {:ok, end_at_hour} = DateTime.new(today, next_hour)
    changeset = Ecto.Changeset.put_change(socket.assigns.changeset, :end_at, end_at_hour)
    Ghost.Repo.insert(changeset)

    socket =
      socket
      |> assign(:predictions, sorted_predictions())
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event("end-at-today", _, socket) do
    end_at_today = Timex.today() |> Timex.to_datetime() |> Timex.shift(days: 1)
    changeset = Ecto.Changeset.put_change(socket.assigns.changeset, :end_at, end_at_today)
    Ghost.Repo.insert(changeset)

    socket =
      socket
      |> assign(:predictions, sorted_predictions())
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event("end-at-tomorrow", _, socket) do
    end_at_tomorrow = Timex.today() |> Timex.to_datetime() |> Timex.shift(days: 2)
    changeset = Ecto.Changeset.put_change(socket.assigns.changeset, :end_at, end_at_tomorrow)
    Ghost.Repo.insert(changeset)

    socket =
      socket
      |> assign(:predictions, sorted_predictions())
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"prediction" => prediction_params}, socket) do
    changeset = Ghost.Prediction.changeset(%Ghost.Prediction{}, prediction_params)

    socket =
      with {:ok, _} <- Ghost.Repo.insert(changeset) do
        socket
        |> assign(:predictions, sorted_predictions())
        |> assign(:changeset, changeset)
      else
        {:error, changeset} ->
          socket
          |> assign(:changeset, changeset)
      end

    {:noreply, socket}
  end

  def handle_event("delete", %{"prediction-id" => prediction_id}, socket) do
    id = prediction_id |> String.to_integer()
    %Ghost.Prediction{id: id} |> Ghost.Repo.delete()

    socket =
      socket
      |> assign(:predictions, sorted_predictions())

    {:noreply, socket}
  end

  defp sorted_predictions do
    Ecto.Query.from(
      b in "predictions",
      order_by: [asc: :end_at],
      select: [:id, :end_at, :base, :quote, :price, :source]
    )
    |> Ghost.Repo.all()
  end
end
