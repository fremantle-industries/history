defmodule Ghost.Repo.Migrations.CreatePredictedFundingRateJobs do
  use Ecto.Migration

  def up do
    create table(:predicted_funding_rate_jobs) do
      add :products, {:array, :jsonb}, null: false
      add :status, Ghost.JobStatusType.type(), null: false

      timestamps()
    end
  end

  def down do
    drop table(:predicted_funding_rate_jobs)
  end
end
