defmodule History.DataAdapters.Ftx.LendingRates do
  def period do
    {:ok, one_hour} = Time.new(1, 0, 0, 0)
    {seconds, _ms} = Time.to_seconds_after_midnight(one_hour)
    {:ok, seconds}
  end

  def periods_per_chunk do
    # 20 days
    {:ok, 480}
  end

  def fetch(chunk) do
    start_time = DateTime.to_unix(chunk.start_at)
    end_time = DateTime.to_unix(chunk.end_at)
    coin = String.upcase(chunk.token)
    params = %{coin: coin, start_time: start_time, end_time: end_time}
    ExFtx.SpotMargin.LendingHistory.get(params)
  end
end
