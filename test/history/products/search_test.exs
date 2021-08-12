defmodule History.Products.SearchTest do
  use History.DataCase
  alias History.Factories

  test "returns all products when the search query is nil" do
    {:ok, spot_product} = Factories.Product.create(%{symbol: "btc/usd", type: :spot})
    {:ok, swap_product} = Factories.Product.create(%{symbol: "btc-perp", type: :swap})

    products = History.Products.search(nil)
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product)
    assert Enum.member?(products, swap_product)
  end

  test "returns queried product that match the venue or symbol" do
    {:ok, spot_product_1} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc/usd", type: :spot})

    {:ok, spot_product_2} =
      Factories.Product.create(%{venue: "venue_b", symbol: "btc/usd", type: :spot})

    {:ok, swap_product} =
      Factories.Product.create(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.search("enue_")
    assert Enum.count(products) == 3
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert Enum.member?(products, swap_product)

    products = History.Products.search("venue_a")
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, swap_product)

    products = History.Products.search("tc")
    assert Enum.count(products) == 3
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert Enum.member?(products, swap_product)

    products = History.Products.search("usd")
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
  end
end
