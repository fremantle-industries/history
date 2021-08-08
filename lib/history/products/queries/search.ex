defmodule History.Products.Queries.Search do
  require Ecto.Query
  import Ecto.Query
  alias History.Products

  def call(query) do
    from(
      p in Products.Product,
      where: ilike(p.symbol, ^"%#{query}%") or ilike(p.venue, ^"%#{query}%"),
      order_by: [asc: :symbol, asc: :venue, asc: :type],
    )
  end
end
