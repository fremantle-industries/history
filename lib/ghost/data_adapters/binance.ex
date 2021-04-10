defmodule Ghost.DataAdapters.Binance do
  alias Ghost.DataAdapters.NoOp

  def funding_rates, do: NoOp.FundingRates
  def lending_rates, do: NoOp.LendingRates
end
