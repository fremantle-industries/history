defmodule Ghost.Tokens.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :name, :string
    field :symbol, :string
    field :collateral, :boolean
    field :collateral_weight, :decimal

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:name, :symbol, :collateral, :collateral_weight])
    |> validate_required([:name, :symbol, :collateral])
    |> unique_constraint([:name, :symbol])
  end
end
