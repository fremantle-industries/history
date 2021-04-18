defmodule Ghost.Repo.Migrations.CreateLendingRateHistoryJobs do
  use Ecto.Migration

  def up do
    Ghost.LendingRateHistoryJobs.LendingRateHistoryJobStatusType.create_type()

    create table(:lending_rate_history_jobs) do
      add :from_date, :date, null: false
      add :from_time, :time, null: false
      add :to_date, :date, null: false
      add :to_time, :time, null: false
      add :tokens, {:array, :jsonb}, null: false
      add :status, Ghost.LendingRateHistoryJobs.LendingRateHistoryJobStatusType.type(), null: false

      timestamps()
    end
  end

  def down do
    drop table(:lending_rate_history_jobs)
    Ghost.LendingRateHistoryJobs.LendingRateHistoryJobStatusType.drop_type()
  end
end
