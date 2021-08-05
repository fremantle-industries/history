defmodule History.DataAdapters.NoOp.PredictedFundingRates do
  def fetch(_chunk) do
    {:error, :not_supported}
  end
end
