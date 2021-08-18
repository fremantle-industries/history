defmodule History.Products.SpotTest do
  use History.DataCase
  alias History.Factories

  test "returns spot products" do
    {:ok, spot_product_1} = Factories.Product.create(%{symbol: "btc/usd", type: :spot})
    {:ok, spot_product_2} = Factories.Product.create(%{symbol: "eth/usd", type: :spot})
    {:ok, swap_product} = Factories.Product.create(%{symbol: "btc-perp", type: :swap})

    products = History.Products.spot()
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert !Enum.member?(products, swap_product)
  end
end
