defmodule History.Products.ByVenueAndSymbolAndTypeTest do
  use History.DataCase
  alias History.Factories

  test "returns products that match the venue, symbol and type" do
    {:ok, spot_product_1} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc/usd", type: :spot})

    {:ok, spot_product_2} =
      Factories.Product.create(%{venue: "venue_b", symbol: "btc/usd", type: :spot})

    {:ok, swap_product} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products =
      History.Products.by_venue_and_symbol_and_type([
        {"venue_a", "btc/usd", :spot},
        {"venue_b", "btc/usd", :spot}
      ])

    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert !Enum.member?(products, swap_product)
  end

  test "returns products that match the venue, type and a symbol wildcard" do
    {:ok, spot_product_1} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc/usd", type: :spot})

    {:ok, spot_product_2} =
      Factories.Product.create(%{venue: "venue_b", symbol: "btc/usd", type: :spot})

    {:ok, swap_product} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.by_venue_and_symbol_and_type([{"venue_a", "*", :spot}])
    assert Enum.count(products) == 1
    assert Enum.member?(products, spot_product_1)
    assert !Enum.member?(products, swap_product)
    assert !Enum.member?(products, spot_product_2)
  end

  test "returns products that match the symbol, type and a venue wildcard" do
    {:ok, spot_product_1} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc/usd", type: :spot})

    {:ok, spot_product_2} =
      Factories.Product.create(%{venue: "venue_b", symbol: "btc/usd", type: :spot})

    {:ok, swap_product} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.by_venue_and_symbol_and_type([{"*", "btc/usd", :spot}])
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert !Enum.member?(products, swap_product)
  end

  test "returns all products with a type, venue wildcard and symbol wildcard" do
    {:ok, spot_product_1} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc/usd", type: :spot})

    {:ok, spot_product_2} =
      Factories.Product.create(%{venue: "venue_b", symbol: "btc/usd", type: :spot})

    {:ok, swap_product} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.by_venue_and_symbol_and_type([{"*", "*", :spot}])
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert !Enum.member?(products, swap_product)
  end
end
