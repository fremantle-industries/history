defmodule Ghost.Repo.Migrations.CreatePredictions do
  use Ecto.Migration

  def change do
    create table(:predictions) do
      add :end_at, :utc_datetime, null: false
      add :base, :string, null: false
      add :quote, :string, null: false
      add :price, :decimal, null: false
      add :source, :string, null: false

      timestamps()
    end

  end
end
