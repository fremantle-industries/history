defmodule History.Factories.Product do
  @default_product_attrs %{
    venue: "venue_a",
    symbol: "btc_usd",
    venue_symbol: "BTC-USD",
    base: "btc",
    quote: "usd",
    type: :spot
  }

  @spec create(map) :: term
  def create(attrs) do
    merged_attrs = Map.merge(@default_product_attrs, attrs)

    %History.Products.Product{}
    |> History.Products.Product.changeset(merged_attrs)
    |> History.Repo.insert()
  end
end
