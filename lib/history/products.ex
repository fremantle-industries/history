defmodule History.Products do
  require Ecto.Query
  alias History.{Products, Repo}

  @type product :: Products.Product.t()

  def import do
    Products.Services.Import.call()
  end

  @spec all :: [product]
  def all do
    "*"
    |> Products.Queries.ByType.call()
    |> Repo.all()
  end

  @spec spot :: [product]
  def spot do
    "spot"
    |> Products.Queries.ByType.call()
    |> Repo.all()
  end

  @spec swap :: [product]
  def swap do
    "swap"
    |> Products.Queries.ByType.call()
    |> Repo.all()
  end

  def symbols do
    Products.Queries.Symbols.call()
    |> Repo.all()
  end

  def search(query) do
    query
    |> Products.Queries.Search.call()
    |> Repo.all()
  end

  def by_venue_and_symbol(products) do
    products
    |> Products.Queries.ByVenueAndSymbol.call()
    |> Repo.all()
  end

  def by_venue_and_symbol_and_type(products) do
    products
    |> Products.Queries.ByVenueAndSymbolType.call()
    |> Repo.all()
  end

  def delete(id) when is_number(id), do: %Products.Product{id: id} |> Repo.delete()
  def delete(id) when is_bitstring(id), do: id |> String.to_integer() |> delete()
end
