defmodule History.Trades.Trade do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trades" do
    field :time, :utc_datetime
    field :venue, :string
    field :product, :string
    field :venue_order_id, :string
    field :side, :string
    field :price, :decimal
    field :qty, :decimal
    field :liquidation, :boolean
    field :source, :string

    timestamps()
  end

  @doc false
  def changeset(trade, attrs) do
    trade
    |> cast(attrs, [
      :time,
      :venue,
      :product,
      :venue_order_id,
      :side,
      :price,
      :qty,
      :liquidation,
      :source
    ])
    |> validate_required([
      :time,
      :venue,
      :product,
      :venue_order_id,
      :side,
      :price,
      :qty,
      :source
    ])
    |> unique_constraint([:time, :venue, :product, :source])
  end
end
