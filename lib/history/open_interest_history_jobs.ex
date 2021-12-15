defmodule History.OpenInterestHistoryJobs do
  alias History.OpenInterests.OpenInterestHistoryJob, as: Job
  alias History.{Repo, Shared}

  @behaviour History.JobFacade

  @type latest_opts :: History.JobFacade.latest_opts
  @type job :: Job.t()
  @type job_id :: History.JobFacade.job_id
  @type job_status :: History.JobFacade.job_status
  @type attributes :: map

  @spec get!(job_id) :: job
  def get!(id) do
    Repo.get!(Job, id)
  end

  @spec latest([History.JobFacade.latest_opts]) :: [job]
  def latest(opts) do
    Job
    |> Shared.Queries.Latest.call(opts)
    |> Repo.all()
  end

  @spec job_changeset(attributes) :: Ecto.Changeset.t()
  def job_changeset(attrs) do
    Job.changeset(%Job{}, attrs)
  end

  @spec count :: non_neg_integer
  def count do
    Repo.aggregate(Job, :count)
  end

  @spec enqueued_after(job_id, count :: pos_integer) :: [job]
  def enqueued_after(job_id, count) do
    Job
    |> Shared.Queries.JobEnqueuedAfter.call(job_id, count)
    |> Repo.all()
  end

  @spec insert(attributes) :: {:ok, struct} | {:error, Ecto.Changeset.t()}
  def insert(attrs) do
    Shared.Services.JobInsert.call(Job, attrs)
  end

  @spec update(job, attributes) :: {:ok, job} | {:error, Ecto.Changeset.t()}
  def update(job, attrs) do
    Shared.Services.JobUpdate.call(job, attrs)
  end

  @spec cancel(job) :: {:ok, job} | {:error, Ecto.Changeset.t()}
  def cancel(job) do
    Shared.Services.JobCancel.call(job)
  end

  @spec subscribe_by_id(job_id | String.t()) :: :ok | {:error, term}
  def subscribe_by_id(job_id) do
    subscribe_by_id(job_id, Tai.PubSub)
  end

  @spec subscribe_by_id(job_id | String.t(), module) :: :ok | {:error, term}
  def subscribe_by_id(job_id, pub_sub) do
    Shared.Services.JobSubscribeById.call(
      "open_interest",
      job_id,
      pub_sub
    )
  end

  @spec broadcast(job_id, job_status) :: no_return
  def broadcast(job_id, job_status) do
    broadcast(job_id, job_status, Tai.PubSub)
  end

  @spec broadcast(job_id, job_status, module) :: no_return
  def broadcast(job_id, job_status, pub_sub) do
    Shared.Services.JobBroadcast.call(
      "open_interest",
      job_id,
      job_status,
      pub_sub
    )
  end
end
