defmodule History.DataAdapters.Bitmex do
  alias History.DataAdapters.NoOp

  @behaviour History.DataAdapter

  @impl true
  def trades, do: NoOp.FundingRates

  @impl true
  def liquidations, do: NoOp.Liquidations

  @impl true
  def funding_rates, do: NoOp.FundingRates

  @impl true
  def predicted_funding_rates, do: NoOp.PredictedFundingRates

  @impl true
  def lending_rates, do: NoOp.LendingRates
end
