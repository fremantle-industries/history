defmodule History.PredictedFundingRateJobs do
  require Ecto.Query
  require Indifferent
  import Ecto.Query
  alias History.Repo
  alias History.PredictedFundingRates.PredictedFundingRateJob, as: Job

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
      f in Job,
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
      f in Job,
      where: f.id > ^id and f.status == "enqueued",
      order_by: [asc: :id],
      limit: ^count
    )
    |> Repo.all()
  end

  def changeset(params) do
    merged_params = Map.merge(params, %{})
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
end
