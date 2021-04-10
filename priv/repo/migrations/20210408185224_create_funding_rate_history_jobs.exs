defmodule Ghost.Repo.Migrations.CreateFundingRateHistoryJobs do
  use Ecto.Migration

  def up do
    Ghost.FundingRateHistoryJobs.FundingRateHistoryJobStatusType.create_type()

    create table(:funding_rate_history_jobs) do
      add :from_date, :date, null: false
      add :from_time, :time, null: false
      add :to_date, :date, null: false
      add :to_time, :time, null: false
      add :products, {:array, :jsonb}, null: false
      add :status, Ghost.FundingRateHistoryJobs.FundingRateHistoryJobStatusType.type(), null: false

      timestamps()
    end
  end

  def down do
    drop table(:funding_rate_history_jobs)
    Ghost.FundingRateHistoryJobs.FundingRateHistoryJobStatusType.drop_type()
  end
end
