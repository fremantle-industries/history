defmodule Ghost.JobStatusType do
  use EctoEnum,
    type: :job_status_type,
    enums: [:enqueued, :error, :working, :complete]
end
