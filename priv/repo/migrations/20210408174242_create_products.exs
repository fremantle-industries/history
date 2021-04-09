defmodule Ghost.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def up do
    Ghost.ProductType.create_type()

    create table(:products) do
      add :venue, :string, null: false
      add :symbol, :string, null: false
      add :venue_symbol, :string, null: false
      add :base, :string, null: false
      add :quote, :string, null: false
      add :type, Ghost.ProductType.type(), null: false

      timestamps()
    end

    create unique_index(:products, [:venue, :symbol, :type])
  end

  def down do
    drop table(:products)
    Ghost.ProductType.drop_type()
  end
end
