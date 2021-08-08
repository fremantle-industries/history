defmodule History.Products.SpotTest do
  use History.DataCase

  test "returns spot products" do
    {:ok, spot_product_1} = create_product(%{symbol: "btc/usd", type: :spot})
    {:ok, spot_product_2} = create_product(%{symbol: "eth/usd", type: :spot})
    {:ok, swap_product} = create_product(%{symbol: "btc-perp", type: :swap})

    products = History.Products.spot()
    assert Enum.any?(products)
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert !Enum.member?(products, swap_product)
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
