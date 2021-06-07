defmodule Ghost.FundingRateHistoryChunks.FundingRateHistoryChunkStatusType do
  use EctoEnum,
    type: :funding_rate_history_chunk_status_type,
    enums: [:enqueued, :error, :working, :not_found, :complete]
end
