defmodule Ghost.PredictedFundingRateJobs do
  require Ecto.Query
  require Indifferent
  import Ecto.Query
  alias Ghost.Repo

  alias Ghost.PredictedFundingRates.{
    PredictedFundingRateJob,
    PredictedFundingRateChunk
  }

  @default_latest_page 1
  @default_latest_page_size 25
  @max_page_size 100

  def get!(id) do
    from(
      j in PredictedFundingRateJob,
      where: j.id == ^id
    )
    |> Repo.one()
  end

  def latest(opts) do
    page = max((opts[:page] || @default_latest_page) - 1, 0)
    page_size = min(opts[:page_size] || @default_latest_page_size, @max_page_size)
    offset = page * page_size

    from(
      f in PredictedFundingRateJob,
      order_by: [desc: :inserted_at],
      offset: ^offset,
      limit: ^page_size
    )
    |> Repo.all()
  end

  def count do
    from(
      j in PredictedFundingRateJob,
      select: count(j.id)
    )
    |> Repo.one()
  end

  def enqueued_after(id, count) do
    from(
      f in PredictedFundingRateJob,
      where: f.id > ^id and f.status == "enqueued",
      order_by: [asc: :id],
      limit: ^count
    )
    |> Repo.all()
  end

  def each_chunk(job, callback) do
    job.products
    |> Enum.each(fn p ->
      adapter = adapter_for!(p.venue)
      build_each_chunk(job, p.venue, p.symbol, callback)
    end)
  end

  def changeset(params) do
    merged_params = Map.merge(params, %{})
    PredictedFundingRateJob.changeset(%PredictedFundingRateJob{}, merged_params)
  end

  def insert(params) do
    changeset = PredictedFundingRateJob.changeset(%PredictedFundingRateJob{}, params)
    Repo.insert(changeset)
  end

  def update(job, params) do
    changeset = PredictedFundingRateJob.changeset(job, params)
    Repo.update(changeset)
  end

  defp adapter_for!(venue) do
    adapters = :ghost |> Application.get_env(:data_adapters, %{}) |> Indifferent.access()

    case adapters[venue] do
      nil -> raise "predicted funding rate adapter not found for: #{inspect(venue)}"
      adapter -> adapter.funding_rates
    end
  end

  def build_each_chunk(job, venue, product_symbol, callback) do
    chunk = %PredictedFundingRateChunk{
      status: "enqueued",
      job: job,
      venue: venue,
      product: product_symbol
    }

    callback.(chunk)
  end
end
