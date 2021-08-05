defmodule History.LendingRates.LendingRate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lending_rates" do
    field(:time, :utc_datetime)
    field(:token, :string)
    field(:base, :string)
    field(:quote, :string)
    field(:rate, :decimal)
    field(:venue, :string)

    timestamps()
  end

  @doc false
  def changeset(lending_rate, attrs) do
    lending_rate
    |> cast(attrs, [:time, :venue, :token, :base, :quote, :rate])
    |> validate_required([:time, :venue, :token, :base, :quote, :rate])
  end

  @one_hundred Decimal.new(100)
  def rate_pct(lending_rate) do
    lending_rate.rate
    |> Decimal.mult(@one_hundred)
    |> Decimal.normalize()
  end
end
