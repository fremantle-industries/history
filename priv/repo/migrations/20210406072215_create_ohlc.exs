defmodule Ghost.Repo.Migrations.CreateOhlc do
  use Ecto.Migration

  def up do
    Ghost.PeriodType.create_type()

    create table(:ohlc) do
      add :period, Ghost.PeriodType.type(), null: false
      add :time, :utc_datetime, null: false
      add :base, :string, null: false
      add :quote, :string, null: false
      add :open, :decimal, null: false
      add :high, :decimal, null: false
      add :low, :decimal, null: false
      add :close, :decimal, null: false
      add :volume, :decimal, null: false
      add :source, :string, null: false

      timestamps()
    end

    create unique_index(:ohlc, [:period, :time, :base, :quote, :source])
  end

  def down do
    drop table(:ohlc)
    Ghost.PeriodType.drop_type()
  end
end
