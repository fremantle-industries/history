defmodule History.Products.ByVenueAndSymbolTest do
  use History.DataCase
  alias History.Factories

  test "returns products that match both the venue and symbol" do
    {:ok, spot_product_1} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc/usd", type: :spot})

    {:ok, spot_product_2} =
      Factories.Product.create(%{venue: "venue_b", symbol: "btc/usd", type: :spot})

    {:ok, swap_product} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products =
      History.Products.by_venue_and_symbol([{"venue_a", "btc/usd"}, {"venue_b", "btc/usd"}])

    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert !Enum.member?(products, swap_product)
  end

  test "returns products that match the venue and a symbol wildcard" do
    {:ok, spot_product_1} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc/usd", type: :spot})

    {:ok, spot_product_2} =
      Factories.Product.create(%{venue: "venue_b", symbol: "btc/usd", type: :spot})

    {:ok, swap_product} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.by_venue_and_symbol([{"venue_a", "*"}])
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, swap_product)
    assert !Enum.member?(products, spot_product_2)
  end

  test "returns products that match the symbol and a venue wildcard" do
    {:ok, spot_product_1} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc/usd", type: :spot})

    {:ok, spot_product_2} =
      Factories.Product.create(%{venue: "venue_b", symbol: "btc/usd", type: :spot})

    {:ok, swap_product} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.by_venue_and_symbol([{"*", "btc/usd"}])
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert !Enum.member?(products, swap_product)
  end

  test "returns all products with both a venue and symbol wildcard" do
    {:ok, spot_product_1} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc/usd", type: :spot})

    {:ok, spot_product_2} =
      Factories.Product.create(%{venue: "venue_b", symbol: "btc/usd", type: :spot})

    {:ok, swap_product} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.by_venue_and_symbol([{"*", "*"}])
    assert Enum.count(products) == 3
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert Enum.member?(products, swap_product)
  end
end
