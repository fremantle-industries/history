defmodule Ghost.Repo.Migrations.CreatePredictedFundingRateChunks do
  use Ecto.Migration

  def up do
    create table(:predicted_funding_rate_chunks) do
      add :venue, :string, null: false
      add :product, :string, null: false
      add :job_id, references(:predicted_funding_rate_jobs), null: false
      add :status, Ghost.ChunkStatusType.type(), null: false

      timestamps()
    end
  end

  def down do
    drop table(:predicted_funding_rate_chunks)
  end
end
