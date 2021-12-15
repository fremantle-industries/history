defmodule History.Shared.Services.JobInsert do
  @type job :: struct
  @type job_type :: module
  @type attributes :: map

  @spec call(job_type, attributes) :: {:ok, job} | {:error, Ecto.Changeset.t()}
  def call(job_type, attrs) do
    job_type
    |> struct(%{})
    |> job_type.changeset(attrs)
    |> History.Repo.update()
  end
end
