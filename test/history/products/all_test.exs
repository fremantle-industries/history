defmodule History.Products.AllTest do
  use History.DataCase
  alias History.Factories

  test "returns all products" do
    {:ok, spot_product} = Factories.Product.create(%{symbol: "btc/usd", type: :spot})
    {:ok, swap_product} = Factories.Product.create(%{symbol: "btc-perp", type: :swap})

    products = History.Products.all()
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product)
    assert Enum.member?(products, swap_product)
  end
end
