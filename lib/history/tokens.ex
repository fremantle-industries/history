defmodule History.Tokens do
  require Ecto.Query
  import Ecto.Query
  alias History.Repo
  alias History.Tokens.Token
  alias History.Products.Product

  def all do
    from(
      Token,
      order_by: [asc: :name],
      select: [:id, :name, :symbol]
    )
    |> Repo.all()
  end

  def search(query) do
    from(
      t in Token,
      order_by: [asc: :name],
      select: [:id, :name, :symbol],
      where: ilike(t.name, ^"%#{query}%") or ilike(t.symbol, ^"%#{query}%")
    )
    |> Repo.all()
  end

  def venue_tokens do
    from(
      t in Token,
      join: p in Product,
      on: p.base == t.symbol or p.quote == t.symbol,
      group_by: [t.symbol, p.venue],
      order_by: [asc: p.venue, asc: t.symbol],
      select: {p.venue, t.symbol}
    )
    |> Repo.all()
  end

  def insert(params) do
    changeset = Token.changeset(%Token{}, params)
    Repo.insert(changeset)
  end

  def delete(id) when is_number(id), do: %Token{id: id} |> Repo.delete()
  def delete(id) when is_bitstring(id), do: id |> String.to_integer() |> delete()
end
