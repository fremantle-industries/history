defmodule History.OpenInterests do
  alias History.OpenInterests.{Queries, Services}
  alias History.Repo

  @type open_interest :: OpenInterest.t()
  @type attributes :: map

  def search_latest(opts \\ []) do
    opts
    |> Queries.SearchLatest.query()
    |> Repo.all()
  end

  @spec upsert(attributes) :: {:ok, open_interest} | {:error, Ecto.Changeset.t()}
  def upsert(attrs) do
    Services.Upsert.call(attrs)
  end
end
