defmodule History.Tokens.Queries.Search do
  require Ecto.Query
  import Ecto.Query
  alias History.Tokens

  def call(query) do
    from(
      t in Tokens.Token,
      order_by: [asc: :name],
      where: ilike(t.name, ^"%#{query}%") or ilike(t.symbol, ^"%#{query}%")
    )
  end
end
