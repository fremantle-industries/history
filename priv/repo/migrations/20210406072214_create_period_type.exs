defmodule History.Repo.Migrations.CreatePeriodType do
  use Ecto.Migration

  def up do
    History.PeriodType.create_type()
  end

  def down do
    History.PeriodType.drop_type()
  end
end