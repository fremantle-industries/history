defmodule Ghost.Repo.Migrations.CreateFundingRateHistoryDownloads do
  use Ecto.Migration

  def change do
    create table(:funding_rate_history_downloads) do
      add :from_date, :date, null: false
      add :from_time, :time, null: false
      add :to_date, :date, null: false
      add :to_time, :time, null: false
      add :products, {:array, :jsonb}, null: false

      timestamps()
    end
  end
end
