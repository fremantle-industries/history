defmodule Ghost.LendingRates.LendingRate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lending_rates" do
    field :time, :utc_datetime
    field :product, :string
    field :base, :string
    field :quote, :string
    field :rate, :decimal
    field :venue, :string

    timestamps()
  end

  @doc false
  def changeset(lending_rate, attrs) do
    lending_rate
    |> cast(attrs, [:time, :venue, :product, :base, :quote, :rate])
    |> validate_required([:time, :venue, :product, :base, :quote, :rate])
  end
end
