defmodule History.Products.SymbolsTest do
  use History.DataCase
  alias History.Factories

  test "returns a list of unique symbols from all products" do
    {:ok, _} = Factories.Product.create(%{venue: "venue_a", symbol: "btc/usd", type: :spot})
    {:ok, _} = Factories.Product.create(%{venue: "venue_b", symbol: "btc/usd", type: :spot})
    {:ok, _} = Factories.Product.create(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.symbols()
    assert Enum.count(products) == 2
    assert Enum.member?(products, "btc/usd")
    assert Enum.member?(products, "btc-perp")
  end
end
