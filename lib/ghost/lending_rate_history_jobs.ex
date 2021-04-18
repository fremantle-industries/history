defmodule Ghost.LendingRateHistoryJobs do
  require Ecto.Query
  require Indifferent
  import Ecto.Query
  alias Ghost.Repo
  alias Ghost.LendingRateHistoryChunks.LendingRateHistoryChunk
  alias Ghost.LendingRateHistoryJobs.LendingRateHistoryJob

  @default_latest_page 1
  @default_latest_page_size 25
  @max_page_size 100

  def get!(id) do
    from(
      j in LendingRateHistoryJob,
      where: j.id == ^id
    )
    |> Repo.one()
  end

  def latest(opts) do
    page = max((opts[:page] || @default_latest_page) - 1, 0)
    page_size = min(opts[:page_size] || @default_latest_page_size, @max_page_size)
    offset = page * page_size

    from(
      l in LendingRateHistoryJob,
      order_by: [desc: :inserted_at],
      offset: ^offset,
      limit: ^page_size
    )
    |> Repo.all()
  end

  def count do
    from(
      j in LendingRateHistoryJob,
      select: count(j.id)
    )
    |> Repo.one()
  end

  def enqueued_after(id, count) do
    from(
      f in LendingRateHistoryJob,
      where: f.id > ^id and f.status == "enqueued",
      order_by: [asc: :id],
      limit: ^count
    )
    |> Repo.all()
  end

  def each_chunk(job, callback) do
    {:ok, start_at} = LendingRateHistoryJob.from(job)
    {:ok, end_at} = LendingRateHistoryJob.to(job)

    job.tokens
    |> Enum.each(fn t ->
      adapter = adapter_for!(t.venue)

      with {:ok, period} <- adapter.period(),
           {:ok, periods_per_chunk} <- adapter.periods_per_chunk() do
        build_each_chunk(
          job,
          t.venue,
          t.symbol,
          start_at,
          end_at,
          period,
          periods_per_chunk,
          callback
        )

        # else
        #   {:error, :not_supported} -> :ok
      end
    end)
  end

  def job_changeset_today(params) do
    now = DateTime.utc_now()
    today = now |> DateTime.to_date()
    yesterday = today |> Timex.shift(days: -1)
    current_hour = Time.new!(now.hour, 0, 0)

    merged_params =
      Map.merge(
        params,
        %{
          from_date: yesterday,
          from_time: current_hour,
          to_date: today,
          to_time: current_hour
        }
      )

    LendingRateHistoryJob.changeset(%LendingRateHistoryJob{}, merged_params)
  end

  def insert(params) do
    changeset = LendingRateHistoryJob.changeset(%LendingRateHistoryJob{}, params)
    Repo.insert(changeset)
  end

  def update(job, params) do
    changeset = LendingRateHistoryJob.changeset(job, params)
    Repo.update(changeset)
  end

  defp adapter_for!(venue) do
    adapters = :ghost |> Application.get_env(:data_adapters, %{}) |> Indifferent.access()

    case adapters[venue] do
      nil -> raise "lending rate adapter not found for: #{inspect(venue)}"
      adapter -> adapter.lending_rates
    end
  end

  def build_each_chunk(
        job,
        venue,
        token,
        start_at,
        end_at,
        period,
        periods_per_chunk,
        callback
      ) do
    if Timex.before?(start_at, end_at) do
      chunk_end_at = DateTime.add(start_at, period * periods_per_chunk, :second)
      min_chunk_end_at = Tai.DateTime.min(chunk_end_at, end_at)

      chunk = %LendingRateHistoryChunk{
        status: "enqueued",
        job: job,
        venue: venue,
        token: token,
        start_at: start_at,
        end_at: min_chunk_end_at
      }

      callback.(chunk)

      build_each_chunk(
        job,
        venue,
        token,
        min_chunk_end_at,
        end_at,
        period,
        periods_per_chunk,
        callback
      )
    end
  end
end
