defmodule Ghost.Repo.Migrations.CreateLendingRateHistoryChunks do
  use Ecto.Migration

  def up do
    Ghost.LendingRateHistoryChunks.LendingRateHistoryChunkStatusType.create_type()

    create table(:lending_rate_history_chunks) do
      add :venue, :string, null: false
      add :token, :string, null: false
      add :start_at, :utc_datetime, null: false
      add :end_at, :utc_datetime, null: false
      add :job_id, references(:lending_rate_history_jobs), null: false
      add :status, Ghost.LendingRateHistoryChunks.LendingRateHistoryChunkStatusType.type(), null: false

      timestamps()
    end

    create unique_index(:lending_rate_history_chunks, [:venue, :token, :job_id, :start_at, :end_at])
  end

  def down do
    drop table(:lending_rate_history_chunks)
    Ghost.LendingRateHistoryChunks.LendingRateHistoryChunkStatusType.drop_type()
  end
end
