defmodule Ghost.Repo.Migrations.CreateFundingRateHistoryChunks do
  use Ecto.Migration

  def up do
    Ghost.FundingRateHistoryChunks.FundingRateHistoryChunkStatusType.create_type()

    create table(:funding_rate_history_chunks) do
      add :venue, :string, null: false
      add :product, :string, null: false
      add :start_at, :utc_datetime, null: false
      add :end_at, :utc_datetime, null: false
      add :job_id, references(:funding_rate_history_jobs), null: false
      add :status, Ghost.FundingRateHistoryChunks.FundingRateHistoryChunkStatusType.type(), null: false

      timestamps()
    end

    create unique_index(:funding_rate_history_chunks, [:venue, :product, :job_id, :start_at, :end_at])
  end

  def down do
    drop table(:funding_rate_history_chunks)
    Ghost.FundingRateHistoryChunks.FundingRateHistoryChunkStatusType.drop_type()
  end
end
