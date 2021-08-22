defmodule History.TradeHistoryJobs do
  require Ecto.Query
  import Ecto.Query
  alias History.{DataAdapter, RangeJob, Repo}
  alias History.Trades.{TradeHistoryJob, TradeHistoryChunk}

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

    TradeHistoryJob.changeset(%TradeHistoryJob{}, merged_params)
  end

  @spec get!(TradeHistoryJob.id()) :: TradeHistoryJob.t()
  def get!(id) do
    from(
      j in TradeHistoryJob,
      where: j.id == ^id
    )
    |> Repo.one()
  end

  @default_latest_page 1
  @default_latest_page_size 25
  @max_page_size 100

  def latest(opts) do
    page = max((opts[:page] || @default_latest_page) - 1, 0)
    page_size = min(opts[:page_size] || @default_latest_page_size, @max_page_size)
    offset = page * page_size

    from(
      t in TradeHistoryJob,
      order_by: [desc: :inserted_at],
      offset: ^offset,
      limit: ^page_size
    )
    |> Repo.all()
  end

  def count do
    from(
      t in TradeHistoryJob,
      select: count(t.id)
    )
    |> Repo.one()
  end

  def insert(params) do
    changeset = TradeHistoryJob.changeset(%TradeHistoryJob{}, params)
    Repo.insert(changeset)
  end

  def update(job, params) do
    changeset = TradeHistoryJob.changeset(job, params)
    Repo.update(changeset)
  end

  def enqueued_after(id, count) do
    from(
      t in TradeHistoryJob,
      where: t.id > ^id and t.status == "enqueued",
      order_by: [asc: :id],
      limit: ^count
    )
    |> Repo.all()
  end

  def each_chunk(job, callback) do
    {:ok, start_at} = RangeJob.from(job)
    {:ok, end_at} = RangeJob.to(job)

    job.products
    |> Enum.map(fn p -> {p.venue, p.symbol} end)
    |> History.Products.by_venue_and_symbol()
    |> Enum.each(fn p ->
      {:ok, adapter} = DataAdapter.for_venue(p.venue)
      trade_adapter = adapter.trades()

      with {:ok, period} <- trade_adapter.period(),
           {:ok, periods_per_chunk} = trade_adapter.periods_per_chunk() do
        build_each_chunk(
          job,
          p.venue,
          p.symbol,
          start_at,
          end_at,
          period,
          periods_per_chunk,
          callback
        )
      end
    end)
  end

  defp build_each_chunk(
         job,
         venue,
         product_symbol,
         start_at,
         end_at,
         period,
         periods_per_chunk,
         callback
       ) do
    if Timex.before?(start_at, end_at) do
      chunk_end_at = DateTime.add(start_at, period * periods_per_chunk, :second)
      min_chunk_end_at = Tai.DateTime.min(chunk_end_at, end_at)

      chunk = %TradeHistoryChunk{
        status: "enqueued",
        job: job,
        venue: venue,
        product: product_symbol,
        start_at: start_at,
        end_at: min_chunk_end_at
      }

      callback.(chunk)

      build_each_chunk(
        job,
        venue,
        product_symbol,
        min_chunk_end_at,
        end_at,
        period,
        periods_per_chunk,
        callback
      )
    end
  end
end
