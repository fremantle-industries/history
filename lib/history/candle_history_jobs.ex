defmodule History.CandleHistoryJobs do
  require Ecto.Query
  require Indifferent
  import Ecto.Query
  alias History.Repo
  alias History.Candles.CandleHistoryJob, as: Job

  @spec get!(Job.id()) :: Job.t()
  def get!(id) do
    Repo.get!(Job, id)
  end

  @default_latest_page 1
  @default_latest_page_size 25
  @max_page_size 100

  def latest(opts) do
    page = max((opts[:page] || @default_latest_page) - 1, 0)
    page_size = min(opts[:page_size] || @default_latest_page_size, @max_page_size)
    offset = page * page_size

    from(
      Job,
      order_by: [desc: :inserted_at],
      offset: ^offset,
      limit: ^page_size
    )
    |> Repo.all()
  end

  @spec count :: non_neg_integer
  def count do
    Repo.aggregate(Job, :count)
  end

  def enqueued_after(id, count) do
    from(
      j in Job,
      where: j.id > ^id and j.status == "enqueued",
      order_by: [asc: :id],
      limit: ^count
    )
    |> Repo.all()
  end

  def job_changeset_today(params) do
    now = DateTime.utc_now()
    {:ok, date_now} = Date.new(now.year, now.month, now.day)
    {:ok, time_now} = Time.new(now.hour, 0, 0)
    {:ok, current_hour} = DateTime.new(date_now, time_now)
    from = current_hour |> Timex.shift(days: -1)
    to = current_hour |> Timex.shift(hours: 1)

    merged_params =
      Map.merge(
        params,
        %{
          from_date: from,
          from_time: from,
          to_date: to,
          to_time: to
        }
      )

    Job.changeset(%Job{}, merged_params)
  end

  def insert(params) do
    changeset = Job.changeset(%Job{}, params)
    Repo.insert(changeset)
  end

  def update(job, params) do
    changeset = Job.changeset(job, params)
    Repo.update(changeset)
  end

  def cancel(job) do
    changeset = Job.changeset(job, %{status: :canceled})
    Repo.update(changeset)
  end

  def broadcast(job, pub_sub \\ Tai.PubSub) do
    msg = %{id: job.id, status: job.status}

    [
      "candle_history_job:#{job.id}",
      "candle_history_job:*"
    ]
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(pub_sub, topic, {topic, msg})
    end)
  end

  def subscribe_by_id(id, pub_sub \\ Tai.PubSub) do
    topic = "candle_history_job:#{id}"
    Phoenix.PubSub.subscribe(pub_sub, topic)
  end
end
