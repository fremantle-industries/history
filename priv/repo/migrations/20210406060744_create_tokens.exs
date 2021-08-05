defmodule History.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :name, :string
      add :symbol, :string
      add :collateral, :boolean, null: false
      add :collateral_weight, :decimal, null: false

      timestamps()
    end

    create unique_index(:tokens, [:name, :symbol])
  end
end
