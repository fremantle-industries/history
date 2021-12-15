defmodule History.Shared.Services.JobUpdate do
  @type job :: struct
  @type attributes :: map

  @spec call(job, attributes) :: {:ok, job} | {:error, Ecto.Changeset.t()}
  def call(%job_type{} = job, attrs) do
    job
    |> job_type.changeset(attrs)
    |> History.Repo.update()
  end
end
