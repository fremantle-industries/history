defmodule Ghost.ChunkStatusType do
  use EctoEnum,
    type: :chunk_status_type,
    enums: [:enqueued, :error, :working, :not_found, :complete]
end
