defmodule Ghost.PredictedFundingRateChunks do
  require Ecto.Query
  require Indifferent
  import Ecto.Query
  alias Ghost.Repo
  alias Ghost.PredictedFundingRates.PredictedFundingRateChunk

  @default_latest_page 1
  @default_latest_page_size 25
  @max_page_size 100

  def enqueued_after(id, count) do
    from(
      c in PredictedFundingRateChunk,
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
      c in PredictedFundingRateChunk,
      where: c.job_id == ^job_id,
      order_by: [asc: :product, asc: :venue],
      offset: ^offset,
      limit: ^page_size
    )
    |> Repo.all()
  end

  def count_by_job_id(job_id) do
    from(
      c in PredictedFundingRateChunk,
      select: count(c.id),
      where: c.job_id == ^job_id
    )
    |> Repo.one()
  end

  def count_by_job_id_and_status(job_id, status) do
    from(
      c in PredictedFundingRateChunk,
      select: count(c.id),
      where: c.job_id == ^job_id and c.status == ^status
    )
    |> Repo.one()
  end

  def insert(changeset) do
    Repo.insert(changeset)
  end

  def update(chunk, params) do
    changeset = PredictedFundingRateChunk.changeset(chunk, params)
    Repo.update(changeset)
  end

  def fetch(chunk) do
    adapter = adapter_for!(chunk.venue)
    adapter.fetch(chunk)
  end

  defp adapter_for!(venue) do
    adapters = :ghost |> Application.get_env(:data_adapters, %{}) |> Indifferent.access()

    case adapters[venue] do
      nil -> raise "predicted funding rate adapter not found for: #{inspect(venue)}"
      adapter -> adapter.predicted_funding_rates
    end
  end
end
