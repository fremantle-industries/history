defmodule History.Products.Queries.ByVenueAndSymbolType do
  require Ecto.Query
  import Ecto.Query
  alias History.Products

  def call(products) do
    filter = filter_products(products)

    from(
      p in Products.Product,
      order_by: [asc: :symbol, asc: :venue, asc: :type],
      where: ^filter
    )
  end

  defp filter_products(products) do
    products
    |> Enum.reduce(
      dynamic(false),
      fn
        {"*", "*", type}, acc -> dynamic([p], ^acc or p.type == ^type)
        {venue, "*", type}, acc -> dynamic([p], ^acc or (p.venue == ^venue and p.type == ^type))
        {"*", symbol, type}, acc -> dynamic([p], ^acc or (p.symbol == ^symbol and p.type == ^type))
        {venue, symbol, type}, acc -> dynamic([p], ^acc or (p.venue == ^venue and p.symbol == ^symbol and p.type == ^type))
      end
    )
  end
end
