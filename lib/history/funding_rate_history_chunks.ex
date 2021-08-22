defmodule History.FundingRateHistoryChunks do
  require Ecto.Query
  require Indifferent
  import Ecto.Query
  alias History.{DataAdapter, Repo}
  alias History.FundingRates.FundingRateHistoryChunk, as: Chunk

  @default_latest_page 1
  @default_latest_page_size 25
  @max_page_size 100

  def enqueued_after(id, count) do
    from(
      c in Chunk,
      where: c.id > ^id and c.status == "enqueued",
      order_by: [asc: :id],
      limit: ^count
    )
    |> Repo.all()
  end

  def by_job(job_id, opts) do
    page = max((opts[:page] || @default_latest_page) - 1, 0)
    page_size = min(opts[:page_size] || @default_latest_page_size, @max_page_size)
    offset = page * page_size

    from(
      c in Chunk,
      where: c.job_id == ^job_id,
      order_by: [asc: :start_at, asc: :product, asc: :venue],
      offset: ^offset,
      limit: ^page_size
    )
    |> Repo.all()
  end

  def count_by_job_id(job_id) do
    from(
      c in Chunk,
      select: count(c.id),
      where: c.job_id == ^job_id
    )
    |> Repo.one()
  end

  def count_by_job_id_and_status(job_id, status) do
    from(
      c in Chunk,
      select: count(c.id),
      where: c.job_id == ^job_id and c.status == ^status
    )
    |> Repo.one()
  end

  def insert(changeset) do
    Repo.insert(changeset)
  end

  def update(chunk, params) do
    changeset = Chunk.changeset(chunk, params)
    Repo.update(changeset)
  end

  def fetch(chunk) do
    {:ok, adapter} = DataAdapter.for_venue(chunk.venue)
    funding_rate_adapter = adapter.funding_rates()
    funding_rate_adapter.fetch(chunk)
  end
end
