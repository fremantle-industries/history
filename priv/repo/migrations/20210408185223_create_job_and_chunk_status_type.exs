defmodule Ghost.Repo.Migrations.CreateJobAndChunkStatusType do
  use Ecto.Migration

  def up do
    Ghost.JobStatusType.create_type()
    Ghost.ChunkStatusType.create_type()
  end

  def down do
    Ghost.JobStatusType.drop_type()
    Ghost.ChunkStatusType.drop_type()
  end
end
