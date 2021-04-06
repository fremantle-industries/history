defmodule Ghost.OHLC do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ohlc" do
    field :period, Ghost.PeriodType
    field :time, :utc_datetime
    field :base, :string
    field :quote, :string
    field :open, :decimal
    field :high, :decimal
    field :low, :decimal
    field :close, :decimal
    field :volume, :decimal
    field :source, :string

    timestamps()
  end

  @doc false
  def changeset(ohlc, attrs) do
    ohlc
    |> cast(attrs, [:period, :time, :base, :quote, :open, :high, :low, :close, :volume, :source])
    |> validate_required([
      :period,
      :time,
      :base,
      :quote,
      :open,
      :high,
      :low,
      :close,
      :volume,
      :source
    ])
    |> unique_constraint([:period, :time, :base, :quote, :source])
  end
end
