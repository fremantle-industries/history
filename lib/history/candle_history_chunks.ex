defmodule History.CandleHistoryChunks do
  require Ecto.Query
  require Indifferent
  import Ecto.Query
  alias History.{DataAdapter, Repo}
  alias History.Candles.CandleHistoryChunk, as: Chunk

  @spec get!(Chunk.id()) :: Chunk.t()
  def get!(id) do
    Repo.get!(Chunk, id)
  end

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
      order_by: [asc: :start_at, asc: :product, asc: :venue, asc: :period],
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
      where: c.job_id == ^job_id and c.status in ^status
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
    with {:ok, candle_adapter} <- DataAdapter.for_venue(chunk.venue, :candles) do
      candle_adapter.fetch(chunk)
    end
  end

  def broadcast(chunk, pub_sub \\ Tai.PubSub) do
    msg = %{id: chunk.id, status: chunk.status}

    [
      "candle_history_chunk:#{chunk.id}",
      "candle_history_chunk:job:#{chunk.job_id}:#{chunk.id}",
      "candle_history_chunk:job:#{chunk.job_id}:*",
      "candle_history_chunk:period:#{chunk.period}:#{chunk.id}",
      "candle_history_chunk:period:#{chunk.period}:*",
      "candle_history_chunk:*"
    ]
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(pub_sub, topic, {topic, msg})
    end)
  end

  def subscribe_by_job_id(job_id, pub_sub \\ Tai.PubSub) do
    topic = "candle_history_chunk:job:#{job_id}:*"
    Phoenix.PubSub.subscribe(pub_sub, topic)
  end
end
