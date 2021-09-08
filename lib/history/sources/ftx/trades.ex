defmodule History.Sources.Ftx.Trades do
  def period do
    {:ok, fifteen_minutes} = Time.new(0, 15, 0, 0)
    {seconds, _ms} = Time.to_seconds_after_midnight(fifteen_minutes)
    {:ok, seconds}
  end

  def periods_per_chunk do
    # 15 minutes
    {:ok, 1}
  end

  def fetch(chunk) do
    start_time = DateTime.to_unix(chunk.start_at)
    end_time = DateTime.to_unix(chunk.end_at)
    params = %{start_time: start_time, end_time: end_time}
    ExFtx.Markets.Trades.get(chunk.product, params)
  end
end
