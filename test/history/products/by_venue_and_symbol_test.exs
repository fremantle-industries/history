defmodule History.Products.ByVenueAndSymbolTest do
  use History.DataCase

  test "returns products that match both the venue and symbol" do
    {:ok, spot_product_1} = create_product(%{venue: "venue_a", symbol: "btc/usd", type: :spot})
    {:ok, spot_product_2} = create_product(%{venue: "venue_b", symbol: "btc/usd", type: :spot})
    {:ok, swap_product} = create_product(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.by_venue_and_symbol(
      [{"venue_a", "btc/usd"}, {"venue_b", "btc/usd"}]
    )
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert !Enum.member?(products, swap_product)
  end

  test "returns products that match the venue and a symbol wildcard" do
    {:ok, spot_product_1} = create_product(%{venue: "venue_a", symbol: "btc/usd", type: :spot})
    {:ok, spot_product_2} = create_product(%{venue: "venue_b", symbol: "btc/usd", type: :spot})
    {:ok, swap_product} = create_product(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.by_venue_and_symbol([{"venue_a", "*"}])
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, swap_product)
    assert !Enum.member?(products, spot_product_2)
  end

  test "returns products that match the symbol and a venue wildcard" do
    {:ok, spot_product_1} = create_product(%{venue: "venue_a", symbol: "btc/usd", type: :spot})
    {:ok, spot_product_2} = create_product(%{venue: "venue_b", symbol: "btc/usd", type: :spot})
    {:ok, swap_product} = create_product(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.by_venue_and_symbol([{"*", "btc/usd"}])
    assert Enum.count(products) == 2
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert !Enum.member?(products, swap_product)
  end

  test "returns all products with both a venue and symbol wildcard" do
    {:ok, spot_product_1} = create_product(%{venue: "venue_a", symbol: "btc/usd", type: :spot})
    {:ok, spot_product_2} = create_product(%{venue: "venue_b", symbol: "btc/usd", type: :spot})
    {:ok, swap_product} = create_product(%{venue: "venue_a", symbol: "btc-perp", type: :swap})

    products = History.Products.by_venue_and_symbol([{"*", "*"}])
    assert Enum.count(products) == 3
    assert Enum.member?(products, spot_product_1)
    assert Enum.member?(products, spot_product_2)
    assert Enum.member?(products, swap_product)
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
