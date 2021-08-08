defmodule History.Products.SymbolsTest do
  use History.DataCase

  test "returns a list of unique symbols from all products" do
    {:ok, _} = create_product(%{venue: "venue_a", symbol: "btc/usd", type: :spot})
    {:ok, _} = create_product(%{venue: "venue_b", symbol: "btc/usd", type: :spot})
    {:ok, _} = create_product(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.symbols()
    assert Enum.count(products) == 2
    assert Enum.member?(products, "btc/usd")
    assert Enum.member?(products, "btc-perp")
  end

  @default_attrs %{
    venue: "venue_a",
    symbol: "btc_usd",
    venue_symbol: "BTC-USD",
    base: "btc",
    quote: "usd",
    type: :spot
  }
  defp create_product(attrs) do
    merged_attrs = Map.merge(@default_attrs, attrs)

    %History.Products.Product{}
    |> History.Products.Product.changeset(merged_attrs)
    |> History.Repo.insert()
  end
end
