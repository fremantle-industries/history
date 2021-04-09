require Ecto.Query

alias Ghost.Products.Product
alias Ghost.Repo

[
  %Product{venue: "binance", symbol: "btc-usdt", base: "btc", quote: "usdt", venue_symbol: "BTC-USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "btc/usd", base: "btc", quote: "usd", venue_symbol: "BTC/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "btc/usdt", base: "btc", quote: "usdt", venue_symbol: "BTC/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "btc-perp", base: "btc", quote: "usd", venue_symbol: "BTC-PERP", type: "swap"},

  %Product{venue: "binance", symbol: "eth-usdt", base: "eth", quote: "usdt", venue_symbol: "ETH-USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "eth/usd", base: "eth", quote: "usd", venue_symbol: "ETH/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "eth/usdt", base: "eth", quote: "usdt", venue_symbol: "ETH/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "eth-perp", base: "eth", quote: "usd", venue_symbol: "ETH-PERP", type: "swap"},

  %Product{venue: "binance", symbol: "ltc-usdt", base: "ltc", quote: "usdt", venue_symbol: "BTC-USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "ltc/usd", base: "ltc", quote: "usd", venue_symbol: "BTC/USD", type: "spot"},
  %Product{venue: "ftx", symbol: "ltc/usdt", base: "ltc", quote: "usdt", venue_symbol: "BTC/USDT", type: "spot"},
  %Product{venue: "ftx", symbol: "ltc-perp", base: "ltc", quote: "usd", venue_symbol: "BTC-PERP", type: "swap"},
]
|> Enum.map(fn product ->
  case Ghost.Repo.one(
         Ecto.Query.from(p in Product, where: p.venue == ^product.venue and p.symbol == ^product.symbol and p.type == ^product.type)
       ) do
    nil -> %Product{venue: product.venue, symbol: product.symbol, venue_symbol: product.venue_symbol, base: product.base, quote: product.quote, type: product.type}
    product -> product
  end
end)
|> Enum.map(&Product.changeset(&1, %{}))
|> Enum.each(&Repo.insert_or_update!/1)
