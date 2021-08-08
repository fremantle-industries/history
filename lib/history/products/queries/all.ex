defmodule History.Products.Queries.All do
  require Ecto.Query
  import Ecto.Query
  alias History.Products

  def call do
    from(
      Products.Product,
      order_by: [asc: :symbol, asc: :venue, asc: :type]
    )
  end
end
