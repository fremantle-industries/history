defmodule Ghost.Repo.Migrations.CreateLendingRates do
  use Ecto.Migration

  def change do
    create table(:lending_rates) do
      add :time, :utc_datetime, null: false
      add :venue, :string, null: false
      add :product, :string, null: false
      add :base, :string, null: false
      add :quote, :string, null: false
      add :rate, :decimal, null: false

      timestamps()
    end

    create unique_index(:lending_rates, [:time, :venue, :product])
  end
end
