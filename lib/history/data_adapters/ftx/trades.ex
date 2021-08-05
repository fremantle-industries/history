defmodule History.DataAdapters.Ftx.Trades do
  def period do
    {:ok, one_hour} = Time.new(1, 0, 0, 0)
    {seconds, _ms} = Time.to_seconds_after_midnight(one_hour)
    {:ok, seconds}
  end

  def periods_per_chunk do
    # 4 hours
    {:ok, 4}
  end

  def fetch(chunk) do
    start_time = DateTime.to_unix(chunk.start_at)
    end_time = DateTime.to_unix(chunk.end_at)
    params = %{start_time: start_time, end_time: end_time}
    ExFtx.Markets.Trades.get(chunk.product, params)
  end
end
