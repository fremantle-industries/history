defmodule History.Products.Queries.Symbols do
  require Ecto.Query
  import Ecto.Query

  def call do
    from(
      p in "products",
      select: p.symbol,
      group_by: p.symbol,
      order_by: [asc: :symbol]
    )
  end
end
