defmodule History.Sources.NoOp.OpenInterests do
  def fetch(_chunk) do
    {:error, :not_supported}
  end
end
