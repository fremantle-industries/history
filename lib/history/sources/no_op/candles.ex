defmodule History.Sources.NoOp.Candles do
  @type chunk :: History.Candles.CandleHistoryChunk.t()

  @spec chunk_range(atom) :: {:error, :not_supported}
  def chunk_range(_period) do
    {:error, :not_supported}
  end

  def fetch(_chunk) do
    {:error, :not_supported}
  end
end
