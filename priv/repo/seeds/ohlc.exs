require Ecto.Query

[
  %Ghost.OHLC{period: "day_1", time: Timex.parse!("2021-04-01 00:00:00Z", "{RFC3339z}"), base: "btc", quote: "usd", open: Decimal.new("58800.01"), high: Decimal.new("59474.94"), low: Decimal.new("57930.0"), close: Decimal.new("58726.48"), volume: Decimal.new("11049.51"), source: "tradingview_coinbase"},
  %Ghost.OHLC{period: "day_1", time: Timex.parse!("2021-04-02 00:00:00Z", "{RFC3339z}"), base: "btc", quote: "usd", open: Decimal.new("58726.47"), high: Decimal.new("60055.02"), low: Decimal.new("58441.88"), close: Decimal.new("58981.04"), volume: Decimal.new("10959.74"), source: "tradingview_coinbase"},
  %Ghost.OHLC{period: "day_1", time: Timex.parse!("2021-04-03 00:00:00Z", "{RFC3339z}"), base: "btc", quote: "usd", open: Decimal.new("58981.04"), high: Decimal.new("59752.0"), low: Decimal.new("56943.0"), close: Decimal.new("57094.34"), volume: Decimal.new("8367.52"), source: "tradingview_coinbase"},
  %Ghost.OHLC{period: "day_1", time: Timex.parse!("2021-04-04 00:00:00Z", "{RFC3339z}"), base: "btc", quote: "usd", open: Decimal.new("57094.34"), high: Decimal.new("58500.0"), low: Decimal.new("56478.53"), close: Decimal.new("58215.94"), volume: Decimal.new("6300.08"), source: "tradingview_coinbase"},
  %Ghost.OHLC{period: "day_1", time: Timex.parse!("2021-04-05 00:00:00Z", "{RFC3339z}"), base: "btc", quote: "usd", open: Decimal.new("58216.73"), high: Decimal.new("59251.76"), low: Decimal.new("56817.64"), close: Decimal.new("59123.02"), volume: Decimal.new("9181.60"), source: "tradingview_coinbase"},
  %Ghost.OHLC{period: "day_1", time: Timex.parse!("2021-04-06 00:00:00Z", "{RFC3339z}"), base: "btc", quote: "usd", open: Decimal.new("59134.07"), high: Decimal.new("59475.0"), low: Decimal.new("57333.33"), close: Decimal.new("58019.98"), volume: Decimal.new("10227.99"), source: "tradingview_coinbase"},
  %Ghost.OHLC{period: "day_1", time: Timex.parse!("2021-04-07 00:00:00Z", "{RFC3339z}"), base: "btc", quote: "usd", open: Decimal.new("58021.67"), high: Decimal.new("58630.0"), low: Decimal.new("55400.0"), close: Decimal.new("55955.75"), volume: Decimal.new("17550.15"), source: "tradingview_coinbase"},
]
|> Enum.map(fn candle ->
  query = Ecto.Query.from(
      c in Ghost.OHLC,
      where: c.period == ^candle.period and c.time == ^candle.time and c.base == ^candle.base and c.quote == ^candle.quote
    )

  case Ghost.Repo.one(query) do
    nil -> %Ghost.OHLC{period: candle.period, time: candle.time, base: candle.base, quote: candle.quote, open: candle.open, high: candle.high, low: candle.low, close: candle.close, volume: candle.volume, source: candle.source}
    candle -> candle
  end
end)
|> Enum.map(&Ghost.OHLC.changeset(&1, %{}))
|> Enum.each(&Ghost.Repo.insert_or_update!/1)
