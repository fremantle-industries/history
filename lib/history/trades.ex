defmodule History.Trades do
  require Ecto.Query
  import Ecto.Query
  alias History.Repo
  alias History.Trades.Trade

  def changeset(params) do
    changeset(%Trade{}, params)
  end

  def changeset(trade, params) do
    Trade.changeset(trade, params)
  end

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
        Trade,
        order_by: [desc: :time, asc: :product, asc: :venue],
        select: [:id, :time, :product, :venue, :price, :qty, :side, :liquidation],
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
        t in Trade,
        select: count(t.id)
      )

    query =
      if search_query do
        where(
          query,
          [t],
          ilike(t.venue, ^"%#{search_query}%") or ilike(t.product, ^"%#{search_query}%")
        )
      else
        query
      end

    query
    |> Repo.one()
  end

  def upsert(params) do
    changeset = Trade.changeset(%Trade{}, params)

    Repo.insert(
      changeset,
      on_conflict: [
        set: [
          price: Ecto.Changeset.get_field(changeset, :price),
          qty: Ecto.Changeset.get_field(changeset, :qty),
          side: Ecto.Changeset.get_field(changeset, :side),
          liquidation: Ecto.Changeset.get_field(changeset, :liquidation),
          updated_at: DateTime.utc_now()
        ]
      ],
      conflict_target: [:time, :venue, :product, :source]
    )
  end

  def delete(id) when is_number(id), do: %Trade{id: id} |> Repo.delete()
  def delete(id) when is_bitstring(id), do: id |> String.to_integer() |> delete()
end
