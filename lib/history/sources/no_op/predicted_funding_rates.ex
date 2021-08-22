defmodule History.Sources.NoOp.PredictedFundingRates do
  def fetch(_chunk) do
    {:error, :not_supported}
  end
end
