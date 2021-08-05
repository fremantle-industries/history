defmodule History.LendingRateHistoryJobs.LendingRateHistoryJobStatusType do
  use EctoEnum,
    type: :lending_rate_history_job_status_type,
    enums: [:enqueued, :error, :working, :complete]
end
