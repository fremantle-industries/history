defmodule History.LendingRateHistoryChunks.LendingRateHistoryChunkStatusType do
  use EctoEnum,
    type: :lending_rate_history_chunk_status_type,
    enums: [:enqueued, :error, :working, :complete]
end
