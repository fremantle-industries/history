defmodule History.OpenInterests.OpenInterest do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "open_interests" do
    field :venue, :string
    field :symbol, :string
    field :value, :decimal

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:venue, :symbol, :value])
    |> validate_required([:venue, :symbol, :value])
    |> unique_constraint([:venue, :symbol])
  end
end
