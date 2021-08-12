defmodule History.Tokens.ByVenueAndSymbolTest do
  use History.DataCase
  alias History.Factories

  setup do
    {:ok, token_a} = Factories.Token.create(%{symbol: "token_a", name: "Token A"})
    {:ok, token_b} = Factories.Token.create(%{symbol: "token_b", name: "Token B"})
    {:ok, token_c} = Factories.Token.create(%{symbol: "token_c", name: "Token C"})

    Factories.Product.create(%{
      base: token_a.symbol,
      quote: "usd",
      venue: "venue_a",
      symbol: "token_a-spot",
      type: "spot"
    })

    Factories.Product.create(%{
      base: "ltc",
      quote: token_b.symbol,
      venue: "venue_b",
      symbol: "token_b-spot",
      type: "spot"
    })

    Factories.Product.create(%{
      base: "btc",
      quote: token_c.symbol,
      venue: "venue_a",
      symbol: "token_c-swap",
      type: "swap"
    })

    {:ok, %{token_a: token_a, token_b: token_b}}
  end

  test "returns a map when a token has at least 1 spot product on the venue as base or quote",
       %{token_a: token_a, token_b: token_b} do
    tokens =
      History.Tokens.by_venue_and_symbol([
        {"venue_a", token_a.symbol},
        {"venue_b", token_b.symbol}
      ])

    assert Enum.count(tokens) == 2
    assert Enum.member?(tokens, %{venue: "venue_a", symbol: "token_a"})
    assert Enum.member?(tokens, %{venue: "venue_b", symbol: "token_b"})
  end

  test "returns a map for all tokens on all venues with spot products matching the base or quote",
       %{token_a: token_a} do
    tokens = History.Tokens.by_venue_and_symbol([{"*", token_a.symbol}])

    assert Enum.count(tokens) == 1
    assert Enum.member?(tokens, %{venue: "venue_a", symbol: "token_a"})
  end

  test "returns a map for all tokens on the matching venue with all spot products matching the base or quote" do
    tokens = History.Tokens.by_venue_and_symbol([{"venue_a", "*"}])

    assert Enum.count(tokens) == 1
    assert Enum.member?(tokens, %{venue: "venue_a", symbol: "token_a"})
  end

  test "returns a map for all tokens with spot products on venues" do
    tokens = History.Tokens.by_venue_and_symbol([{"*", "*"}])

    assert Enum.count(tokens) == 2
    assert Enum.member?(tokens, %{venue: "venue_a", symbol: "token_a"})
    assert Enum.member?(tokens, %{venue: "venue_b", symbol: "token_b"})
  end
end
