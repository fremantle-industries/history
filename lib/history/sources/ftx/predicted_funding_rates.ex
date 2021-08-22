defmodule History.Sources.Ftx.PredictedFundingRates do
  def fetch(chunk) do
    ExFtx.Futures.Stats.get(chunk.product)
  end
end
