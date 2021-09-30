defmodule History.Pipelines.Steps.BuildCandlesFromCandleHistoryChunks do
  require Logger
  alias History.Pipelines.Steps.BuildCandlesFromCandleHistoryChunks.Services

  def execute(chunk_id: chunk_id, period: period) do
    chunk = History.CandleHistoryChunks.get!(chunk_id)
    mins_per_chunk_candle = mins_per_candle(chunk.period)
    mins_per_agg_candle = mins_per_candle(period)

    if rem(mins_per_agg_candle, mins_per_chunk_candle) == 0 do
      chunk_candles_per_agg_candle = trunc(mins_per_agg_candle / mins_per_chunk_candle)

      "build ~w candles from ~w ~w candles with date range from=~s, to=~s"
      |> :io_lib.format([period, chunk_candles_per_agg_candle, chunk.period, chunk.start_at |> inspect, chunk.end_at |> inspect])
      |> List.to_string()
      |> Logger.info()


      # SELECT
      #   oc_grouped_candles.time,
      #   oc_grouped_candles.venue,
      #   oc_grouped_candles.product,
      #   oc_grouped_candles.open,
      #   MAX(oc_grouped_candles.high) AS high,
      #   MIN(oc_grouped_candles.low) AS low,
      #   oc_grouped_candles.close,
      #   SUM(oc_grouped_candles.volume) AS volume
      # FROM (
      #     SELECT
      #       FIRST_VALUE(grouped_candles.time) OVER (
      #         PARTITION BY grouped_candles.venue, grouped_candles.product, grouped_candles.group_id
      #         ORDER BY grouped_candles.time ASC
      #       ) AS time,
      #       grouped_candles.group_id,
      #       grouped_candles.venue,
      #       grouped_candles.product,
      #       FIRST_VALUE(grouped_candles.open) OVER (
      #         PARTITION BY grouped_candles.venue, grouped_candles.product, grouped_candles.group_id
      #         ORDER BY grouped_candles.time ASC
      #       ) AS open,
      #       grouped_candles.high,
      #       grouped_candles.low,
      #       FIRST_VALUE(grouped_candles.close) OVER (
      #         PARTITION BY grouped_candles.venue, grouped_candles.product, grouped_candles.group_id
      #         ORDER BY grouped_candles.time DESC
      #       ) AS close,
      #       grouped_candles.volume
      #     FROM (
      #         SELECT
      #           candles.time,
      #           TRUNC(EXTRACT(epoch FROM (candles.time - '1900-01-01 00:00:00'::TIMESTAMP)) / 60 / 15)::BIGINT AS group_id,
      #           candles.venue,
      #           candles.product,
      #           candles.open,
      #           candles.high,
      #           candles.low,
      #           candles.close,
      #           candles.volume
      #         FROM candles
      #         WHERE
      #           candles.time >= NOW() - INTERVAL '120 minutes'
      #           AND candles.product IN ('btc-perp', 'eth-perp')
      #           AND candles.period = 'min_1'::period_type
      #           AND candles.source = 'api'
      #       ) AS grouped_candles
      #   ) AS oc_grouped_candles
      # GROUP BY
      #   oc_grouped_candles.time,
      #   oc_grouped_candles.venue,
      #   oc_grouped_candles.product,
      #   oc_grouped_candles.open,
      #   oc_grouped_candles.close;

    else
      "can't build a ~w candle from ~w. ~w must be evenly divisible by ~w"
      |> :io_lib.format([period, chunk.period, period, chunk.period])
      |> List.to_string()
      |> Logger.warn()
    end
  end

  defp mins_per_candle(:min_1), do: 1
  defp mins_per_candle(:min_5), do: 5
  defp mins_per_candle(:min_15), do: 15
  defp mins_per_candle(:hour_1), do: 60
  defp mins_per_candle(:hour_2), do: 120
  defp mins_per_candle(:hour_3), do: 180
  defp mins_per_candle(:hour_4), do: 240
  defp mins_per_candle(:hour_6), do: 360
  defp mins_per_candle(:hour_12), do: 720
  defp mins_per_candle(:day_1), do: 1440
  defp mins_per_candle(:week_1), do: 10080
  defp mins_per_candle(:month_1), do: 40320
end
