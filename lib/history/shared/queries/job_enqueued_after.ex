defmodule History.Shared.Queries.JobEnqueuedAfter do
  require Ecto.Query
  import Ecto.Query

  @type job_id :: non_neg_integer
  @type job_type :: module
  @type count :: pos_integer

  @spec call(job_type, job_id, count) :: Ecto.Query.t()
  def call(job_type, job_id, count) do
    from(
      j in job_type,
      where: j.id > ^job_id and j.status == "enqueued",
      order_by: [asc: :id],
      limit: ^count
    )
  end
end
