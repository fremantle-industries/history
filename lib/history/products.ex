defmodule History.Products do
  require Ecto.Query
  alias History.{Products, Repo}

  def import do
    Products.Services.Import.call()
  end

  def spot do
    "spot"
    |> Products.Queries.ByType.call()
    |> Repo.all()
  end

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
