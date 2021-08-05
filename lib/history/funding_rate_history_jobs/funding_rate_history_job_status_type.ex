defmodule History.FundingRateHistoryJobs.FundingRateHistoryJobStatusType do
  use EctoEnum,
    type: :funding_rate_history_job_status_type,
    enums: [:enqueued, :error, :working, :complete]
end
