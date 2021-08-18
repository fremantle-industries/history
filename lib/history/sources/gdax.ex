defmodule History.Sources.Gdax do
  alias History.Sources.NoOp

  @behaviour History.DataAdapter

  @impl true
  def trades, do: NoOp.Trades

  @impl true
  def candles, do: NoOp.Candles

  @impl true
  def liquidations, do: NoOp.Liquidations

  @impl true
  def funding_rates, do: NoOp.FundingRates

  @impl true
  def predicted_funding_rates, do: NoOp.PredictedFundingRates

  @impl true
  def lending_rates, do: NoOp.LendingRates
end
