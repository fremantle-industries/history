defmodule History.Shared.Services.JobCancel do
  @type job :: struct

  @spec call(job) :: {:ok, job} | {:error, Ecto.Changeset.t()}
  def call(%job_type{} = job) do
    job
    |> job_type.changeset(%{status: :canceled})
    |> History.Repo.update()
  end
end
