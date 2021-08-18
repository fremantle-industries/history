defmodule History.Candles do
  require Ecto.Query
  import Ecto.Query
  alias History.Repo
  alias History.Candles.Candle

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
        Candle,
        order_by: [desc: :time, asc: :product, asc: :venue],
        offset: ^offset,
        limit: ^page_size
      )

    query =
      if search_query do
        where(
          query,
          [r],
          ilike(r.venue, ^"%#{search_query}%") or ilike(r.product, ^"%#{search_query}%")
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
        r in Candle,
        select: count(r.id)
      )

    query =
      if search_query do
        where(
          query,
          [r],
          ilike(r.venue, ^"%#{search_query}%") or ilike(r.product, ^"%#{search_query}%")
        )
      else
        query
      end

    query
    |> Repo.one()
  end

  def upsert(params) do
    changeset = Candle.changeset(%Candle{}, params)

    Repo.insert(
      changeset,
      on_conflict: [
        set: [
          time: Ecto.Changeset.get_field(changeset, :time),
          venue: Ecto.Changeset.get_field(changeset, :venue),
          source: Ecto.Changeset.get_field(changeset, :source),
          updated_at: DateTime.utc_now()
        ]
      ],
      conflict_target: [:venue, :product, :source, :period, :time]
    )
  end

  def delete(id) when is_number(id), do: %Candle{id: id} |> Repo.delete()
  def delete(id) when is_bitstring(id), do: id |> String.to_integer() |> delete()
end
