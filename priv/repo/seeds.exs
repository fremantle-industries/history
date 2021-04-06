# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ghost.Repo.insert!(%Ghost.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

require Ecto.Query

[
  %Ghost.Token{name: "Binance Coin", symbol: "bnb"},
  %Ghost.Token{name: "Binance USD", symbol: "busd"},
  %Ghost.Token{name: "Bitcoin", symbol: "btc"},
  %Ghost.Token{name: "Ethereum", symbol: "eth"},
  %Ghost.Token{name: "FTX Token", symbol: "ftt"},
  %Ghost.Token{name: "Litecoin", symbol: "ltc"},
  %Ghost.Token{name: "OKB", symbol: "okb"},
  %Ghost.Token{name: "Polkadot", symbol: "dot"},
  %Ghost.Token{name: "Solana", symbol: "sol"},
  %Ghost.Token{name: "Tether", symbol: "usdt"},
  %Ghost.Token{name: "USD Coin", symbol: "usdc"}
]
|> Enum.map(fn %_{name: name, symbol: symbol} ->
  case Ghost.Repo.one(
         Ecto.Query.from(t in Ghost.Token, where: t.name == ^name and t.symbol == ^symbol)
       ) do
    nil -> %Ghost.Token{name: name, symbol: symbol}
    token -> token
  end
end)
|> Enum.map(&Ghost.Token.changeset(&1, %{}))
|> Enum.each(&Ghost.Repo.insert_or_update!/1)
