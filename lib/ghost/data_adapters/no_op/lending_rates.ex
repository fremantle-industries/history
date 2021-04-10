defmodule Ghost.DataAdapters.NoOp.LendingRates do
  def fetch do
    {:error, :not_supported}
  end
end
