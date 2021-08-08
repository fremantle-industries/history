defmodule History.Products.SearchTest do
  use History.DataCase

  test "returns all products when the search query is nil" do
    {:ok, spot_product} = create_product(%{symbol: "btc/usd", type: :spot})
    {:ok, swap_product} = create_product(%{symbol: "btc-perp", type: :swap})

    products = History.Products.search(nil)
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product)
    assert Enum.member?(products, swap_product)
  end

  test "returns queried product that match the venue or symbol" do
    {:ok, spot_product_1} = create_product(%{venue: "venue_a", symbol: "btc/usd", type: :spot})
    {:ok, spot_product_2} = create_product(%{venue: "venue_b", symbol: "btc/usd", type: :spot})
    {:ok, swap_product} = create_product(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

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
