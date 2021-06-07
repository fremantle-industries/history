defmodule Ghost.DataAdapters.Ftx do
  alias __MODULE__

  def funding_rates, do: Ftx.FundingRates
  def predicted_funding_rates, do: Ftx.PredictedFundingRates
  def lending_rates, do: Ftx.LendingRates
end
