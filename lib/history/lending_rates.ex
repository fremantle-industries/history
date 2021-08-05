defmodule History.LendingRates do
  require Ecto.Query
  import Ecto.Query
  alias History.Repo
  alias History.LendingRates.LendingRate

  @default_latest_page 1
  @default_latest_page_size 25
  @max_page_size 100

  def search_latest(opts \\ []) do
    page = max((opts[:page] || @default_latest_page) - 1, 0)
    page_size = min(opts[:page_size] || @default_latest_page_size, @max_page_size)
    offset = page * page_size
    search_query = opts[:query]

    query =
      from(
        LendingRate,
        order_by: [desc: :time, asc: :token, asc: :venue],
        select: [:id, :time, :token, :venue, :rate],
        offset: ^offset,
        limit: ^page_size
      )

    query =
      if search_query do
        where(
          query,
          [r],
          ilike(r.venue, ^"%#{search_query}%") or ilike(r.token, ^"%#{search_query}%")
        )
      else
        query
      end

    query
    |> Repo.all()
  end

  def count(opts \\ []) do
    search_query = opts[:query]

    query =
      from(
        r in LendingRate,
        select: count(r.id)
      )

    query =
      if search_query do
        where(
          query,
          [r],
          ilike(r.venue, ^"%#{search_query}%") or ilike(r.token, ^"%#{search_query}%")
        )
      else
        query
      end

    query
    |> Repo.one()
  end

  def upsert(params) do
    changeset = LendingRate.changeset(%LendingRate{}, params)

    Repo.insert(
      changeset,
      on_conflict: [
        set: [rate: Ecto.Changeset.get_field(changeset, :rate), updated_at: DateTime.utc_now()]
      ],
      conflict_target: [:time, :venue, :token]
    )
  end

  def delete(id) when is_number(id), do: %LendingRate{id: id} |> Repo.delete()
  def delete(id) when is_bitstring(id), do: id |> String.to_integer() |> delete()
end
