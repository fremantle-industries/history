defmodule History.DataAdapters.NoOp.LendingRates do
  def period do
    {:error, :not_supported}
  end

  def periods_per_chunk do
    {:error, :not_supported}
  end

  def fetch(_chunk) do
    {:error, :not_supported}
  end
end
