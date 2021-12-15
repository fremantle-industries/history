defmodule History.JobFacade do
  @type latest_opts :: {:page, non_neg_integer} | {:page_size, non_neg_integer}
  @type job :: struct
  @type job_id :: non_neg_integer
  @type job_status :: atom
  @type attributes :: map
  @type pub_sub :: module

  @callback get!(job_id) :: job

  @callback latest([latest_opts]) :: [job]

  @callback count() :: non_neg_integer

  @callback enqueued_after(job_id, count :: pos_integer) :: [job]

  @callback insert(attributes) :: {:ok, job} | {:error, Ecto.Changeset.t()}

  @callback update(job, attributes) :: {:ok, job} | {:error, Ecto.Changeset.t()}

  @callback cancel(job) :: {:ok, job} | {:error, Ecto.Changeset.t()}

  @callback subscribe_by_id(job_id) :: :ok | {:error, term}
  @callback subscribe_by_id(job_id, pub_sub) :: :ok | {:error, term}

  @callback broadcast(job_id, job_status) :: no_return
  @callback broadcast(job_id, job_status, pub_sub) :: no_return
end
