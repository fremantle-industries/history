defmodule History.Sources.Ftx.Candles do
  @type chunk :: History.Candles.CandleHistoryChunk.t()

  @seconds_in_1_minute 60
  @seconds_in_1_hour 60 * 60
  @seconds_in_1_day 60 * 60 * 24
  @seconds_in_1_week 60 * 60 * 24 * 7

  @spec chunk_range(atom) :: {:ok, non_neg_integer} | {:error, :not_supported}
  def chunk_range(period) do
    case period do
      :min_1 -> {:ok, @seconds_in_1_hour}
      :min_5 -> {:ok, @seconds_in_1_hour * 2}
      :min_15 -> {:ok, @seconds_in_1_hour * 4}
      :hour_1 -> {:ok, @seconds_in_1_day}
      :hour_2 -> {:ok, @seconds_in_1_day}
      :hour_3 -> {:ok, @seconds_in_1_day}
      :hour_4 -> {:ok, @seconds_in_1_day}
      :hour_6 -> {:ok, @seconds_in_1_day}
      :hour_12 -> {:ok, @seconds_in_1_day}
      :day_1 -> {:ok, @seconds_in_1_week}
      :week_1 -> {:ok, @seconds_in_1_week * 4}
      _ -> {:error, :not_supported}
    end
  end

  def fetch(chunk) do
    start_time = DateTime.to_unix(chunk.start_at)
    end_time = DateTime.to_unix(chunk.end_at)
    resolution = seconds_in_period(chunk.period)
    params = %{start_time: start_time, end_time: end_time}
    ExFtx.Markets.Candles.get(chunk.product, resolution, params)
  end

  defp seconds_in_period(period) do
    case period do
      :min_1 -> @seconds_in_1_minute
      :min_5 -> @seconds_in_1_minute * 5
      :min_15 -> @seconds_in_1_minute * 15
      :hour_1 -> @seconds_in_1_hour
      :hour_2 -> @seconds_in_1_hour * 2
      :hour_3 -> @seconds_in_1_hour * 3
      :hour_4 -> @seconds_in_1_hour * 4
      :hour_6 -> @seconds_in_1_hour * 6
      :hour_12 -> @seconds_in_1_hour * 12
      :day_1 -> @seconds_in_1_day
      :week_1 -> @seconds_in_1_week
      _ -> 0
    end
  end
end
