defmodule History.Sources.Ftx do
  alias __MODULE__

  @behaviour History.DataAdapter

  @impl true
  def trades, do: Ftx.Trades

  @impl true
  def candles, do: Ftx.Candles

  @impl true
  def liquidations, do: Ftx.Liquidations

  @impl true
  def open_interests, do: Ftx.OpenInterests

  @impl true
  def funding_rates, do: Ftx.FundingRates

  @impl true
  def predicted_funding_rates, do: Ftx.PredictedFundingRates

  @impl true
  def lending_rates, do: Ftx.LendingRates
end
