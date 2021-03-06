defmodule History.Tokens.Token do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type venue_and_symbol_key :: {venue :: String.t(), symbol :: String.t()}

  schema "tokens" do
    field :name, :string
    field :symbol, :string

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:name, :symbol])
    |> validate_required([:name, :symbol])
    |> unique_constraint([:name, :symbol])
  end
end
