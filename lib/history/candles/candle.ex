defmodule History.Candles.Candle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "candles" do
    field :venue, :string
    field :product, :string
    field :source, :string
    field :period, History.PeriodType
    field :time, :utc_datetime
    field :open, :decimal
    field :high, :decimal
    field :low, :decimal
    field :close, :decimal
    field :volume, :decimal

    timestamps()
  end

  @doc false
  def changeset(funding_rate, attrs) do
    funding_rate
    |> cast(attrs, [
      :venue,
      :product,
      :source,
      :period,
      :time,
      :open,
      :high,
      :low,
      :close,
      :volume
    ])
    |> validate_required([
      :venue,
      :product,
      :source,
      :period,
      :time,
      :open,
      :high,
      :low,
      :close,
      :volume
    ])
  end
end
