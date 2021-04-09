require Ecto.Query

alias Ghost.FundingRates.FundingRate
alias Ghost.Repo

[
  %FundingRate{time: Timex.parse!("2021-04-01 00:00:00Z", "{RFC3339z}"), product: "btc/usd", base: "btc", quote: "usd", venue: "ftx", rate: Decimal.new("0.0025")},
]
|> Enum.map(fn funding_rate ->
  query = Ecto.Query.from(
      r in FundingRate,
      where: r.time == ^funding_rate.time and r.product == ^funding_rate.product and r.venue == ^funding_rate.venue
    )

  case Ghost.Repo.one(query) do
    nil -> %FundingRate{time: funding_rate.time, product: funding_rate.product, base: funding_rate.base, quote: funding_rate.quote, venue: funding_rate.venue, rate: funding_rate.rate}
    funding_rate -> funding_rate
  end
end)
|> Enum.map(&FundingRate.changeset(&1, %{}))
|> Enum.each(&Repo.insert_or_update!/1)
