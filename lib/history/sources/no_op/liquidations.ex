defmodule History.Sources.NoOp.Liquidations do
  def fetch(_chunk) do
    {:error, :not_supported}
  end
end
