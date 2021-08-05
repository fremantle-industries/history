defmodule History.PredictedFundingRates.PredictedFundingRate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "predicted_funding_rates" do
    field :next_funding_time, :utc_datetime
    field :product, :string
    field :venue, :string
    field :next_funding_rate, :decimal

    timestamps()
  end

  @doc false
  def changeset(funding_rate, attrs) do
    funding_rate
    |> cast(attrs, [:next_funding_time, :venue, :product, :next_funding_rate])
    |> validate_required([:next_funding_time, :venue, :product, :next_funding_rate])
  end

  @one_hundred Decimal.new(100)
  def rate_pct(predicted_rate) do
    predicted_rate.next_funding_rate
    |> Decimal.mult(@one_hundred)
    |> Decimal.normalize()
  end
end
