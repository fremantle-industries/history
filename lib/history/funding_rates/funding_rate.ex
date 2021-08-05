defmodule History.FundingRates.FundingRate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "funding_rates" do
    field :time, :utc_datetime
    field :product, :string
    field :rate, :decimal
    field :venue, :string

    timestamps()
  end

  @doc false
  def changeset(funding_rate, attrs) do
    funding_rate
    |> cast(attrs, [:time, :venue, :product, :rate])
    |> validate_required([:time, :venue, :product, :rate])
  end

  @one_hundred Decimal.new(100)
  def rate_pct(funding_rate) do
    funding_rate.rate
    |> Decimal.mult(@one_hundred)
    |> Decimal.normalize()
  end
end
