defmodule Ghost.FundingRates.FundingRate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "funding_rates" do
    field :time, :utc_datetime
    field :product, :string
    field :base, :string
    field :quote, :string
    field :rate, :decimal
    field :venue, :string

    timestamps()
  end

  @doc false
  def changeset(funding_rate, attrs) do
    funding_rate
    |> cast(attrs, [:time, :venue, :product, :base, :quote, :rate])
    |> validate_required([:time, :venue, :product, :base, :quote, :rate])
  end
end
