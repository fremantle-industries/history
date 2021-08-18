defmodule History.Products.Queries.ByType do
  require Ecto.Query
  import Ecto.Query
  alias History.Products

  def call(product_type) do
    filter = filter_type(product_type)

    from(
      p in Products.Product,
      where: ^filter,
      order_by: [asc: :symbol, asc: :venue, asc: :type]
    )
  end

  defp filter_type(product_type) do
    case product_type do
      "*" -> dynamic([], true)
      product_type -> dynamic([p], p.type == ^product_type)
    end
  end
end
