defmodule History.JobStatusType do
  use EctoEnum,
    type: :job_status_type,
    enums: [:enqueued, :error, :working, :complete, :canceled]
end
