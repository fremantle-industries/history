require Ecto.Query

[
  %Ghost.Tokens.Token{name: "1inch", symbol: "1inch"},
  %Ghost.Tokens.Token{name: "Aave", symbol: "aave"},
  %Ghost.Tokens.Token{name: "Alchemix", symbol: "alcx"},
  %Ghost.Tokens.Token{name: "Alpha Finance", symbol: "alpha"},
  %Ghost.Tokens.Token{name: "Audius", symbol: "audio"},
  %Ghost.Tokens.Token{name: "Axie Infinity", symbol: "axs"},
  %Ghost.Tokens.Token{name: "BUSD", symbol: "busd"},
  %Ghost.Tokens.Token{name: "Badger DAO", symbol: "badger"},
  %Ghost.Tokens.Token{name: "Binance Coin", symbol: "bnb"},
  %Ghost.Tokens.Token{name: "Binance USD", symbol: "busd"},
  %Ghost.Tokens.Token{name: "Bitcoin Cash", symbol: "bch"},
  %Ghost.Tokens.Token{name: "Bitcoin", symbol: "btc"},
  %Ghost.Tokens.Token{name: "Chainlink", symbol: "link"},
  %Ghost.Tokens.Token{name: "Crypto.com", symbol: "cro"},
  %Ghost.Tokens.Token{name: "Dogecoin", symbol: "doge"},
  %Ghost.Tokens.Token{name: "Ethereum", symbol: "eth"},
  %Ghost.Tokens.Token{name: "Bonfida", symbol: "fida"},
  %Ghost.Tokens.Token{name: "FTX Token", symbol: "ftt"},
  %Ghost.Tokens.Token{name: "Litecoin", symbol: "ltc"},
  %Ghost.Tokens.Token{name: "Maker", symbol: "mkr"},
  %Ghost.Tokens.Token{name: "OKB", symbol: "okb"},
  %Ghost.Tokens.Token{name: "Oxygen", symbol: "oxy"},
  %Ghost.Tokens.Token{name: "Polkadot", symbol: "dot"},
  %Ghost.Tokens.Token{name: "Polygon", symbol: "matic"},
  %Ghost.Tokens.Token{name: "Raydium", symbol: "ray"},
  %Ghost.Tokens.Token{name: "Serum", symbol: "srm"},
  %Ghost.Tokens.Token{name: "Solana", symbol: "sol"},
  %Ghost.Tokens.Token{name: "Swipe", symbol: "sxp"},
  %Ghost.Tokens.Token{name: "THORChain", symbol: "rune"},
  %Ghost.Tokens.Token{name: "Tether", symbol: "usdt"},
  %Ghost.Tokens.Token{name: "Tron", symbol: "trx"},
  %Ghost.Tokens.Token{name: "USD Coin", symbol: "usdc"},
  %Ghost.Tokens.Token{name: "USD", symbol: "usd"},
  %Ghost.Tokens.Token{name: "Uniswap", symbol: "uni"},
  %Ghost.Tokens.Token{name: "XRP", symbol: "xrp"},
]
|> Enum.map(fn %_{name: name, symbol: symbol} ->
  case Ghost.Repo.one(
         Ecto.Query.from(t in Ghost.Tokens.Token, where: t.name == ^name and t.symbol == ^symbol)
       ) do
    nil -> %Ghost.Tokens.Token{name: name, symbol: symbol}
    token -> token
  end
end)
|> Enum.map(&Ghost.Tokens.Token.changeset(&1, %{}))
|> Enum.each(&Ghost.Repo.insert_or_update!/1)
