defmodule Ghost.DataAdapters.Binance do
  alias Ghost.DataAdapters.NoOp

  def funding_rates, do: NoOp.FundingRates
  def predicted_funding_rates, do: NoOp.PredictedFundingRates
  def lending_rates, do: NoOp.LendingRates
end
