defmodule Ghost.Prediction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "predictions" do
    field :end_at, :utc_datetime
    field :base, :string
    field :quote, :string
    field :price, :decimal
    field :source, :string

    timestamps()
  end

  @doc false
  def changeset(prediction, attrs) do
    prediction
    |> cast(attrs, [:end_at, :base, :quote, :price, :source])
    |> validate_required([:end_at, :base, :quote, :price, :source])
  end
end
