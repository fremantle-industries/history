defmodule History.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field(:base, :string)
    field(:quote, :string)
    field(:symbol, :string)
    field(:type, History.ProductType)
    field(:venue, :string)
    field(:venue_symbol, :string)

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:venue, :symbol, :venue_symbol, :base, :quote, :type])
    |> validate_required([:venue, :symbol, :venue_symbol, :base, :quote, :type])
  end
end
