defmodule History.Products.Queries.ByVenueAndSymbol do
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
        {"*", "*"}, acc -> dynamic([p], ^acc or true)
        {venue, "*"}, acc -> dynamic([p], ^acc or p.venue == ^venue)
        {"*", symbol}, acc -> dynamic([p], ^acc or p.symbol == ^symbol)
        {venue, symbol}, acc -> dynamic([p], ^acc or (p.venue == ^venue and p.symbol == ^symbol))
      end
    )
  end
end
