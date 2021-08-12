defmodule History.Tokens.SearchTest do
  use History.DataCase
  alias History.Factories

  test "returns all tokens when the search query is nil" do
    {:ok, btc_token} = Factories.Token.create(%{name: "Bitcoin", symbol: "btc"})
    {:ok, eth_token} = Factories.Token.create(%{name: "Ethereum", symbol: "eth"})

    tokens = History.Tokens.search(nil)
    assert Enum.count(tokens) == 2
    assert Enum.member?(tokens, btc_token)
    assert Enum.member?(tokens, eth_token)
  end

  test "returns queried product that match the venue or symbol" do
    {:ok, btc_token} = Factories.Token.create(%{name: "Bitcoin", symbol: "btc"})
    {:ok, ltc_token} = Factories.Token.create(%{name: "Litecoin", symbol: "ltc"})
    {:ok, eth_token} = Factories.Token.create(%{name: "Ethereum", symbol: "eth"})

    tokens = History.Tokens.search("coin")
    assert Enum.count(tokens) == 2
    assert Enum.member?(tokens, btc_token)
    assert Enum.member?(tokens, ltc_token)

    tokens = History.Tokens.search("tc")
    assert Enum.count(tokens) == 2
    assert Enum.member?(tokens, btc_token)
    assert Enum.member?(tokens, ltc_token)

    tokens = History.Tokens.search("eth")
    assert Enum.count(tokens) == 1
    assert Enum.member?(tokens, eth_token)
  end
end
