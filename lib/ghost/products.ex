defmodule Ghost.Products do
  require Ecto.Query
  alias Ghost.Repo
  alias Ghost.Products.Product

  def all do
    Product
    |> Ecto.Query.order_by(asc: :symbol, asc: :venue, asc: :type)
    |> Repo.all()
  end

  def spot do
    Product
    |> Ecto.Query.where(type: "spot")
    |> Ecto.Query.order_by(asc: :venue, asc: :symbol, asc: :type)
    |> Repo.all()
  end

  def swap do
    Product
    |> Ecto.Query.where(type: "swap")
    |> Ecto.Query.order_by(asc: :venue, asc: :symbol, asc: :type)
    |> Repo.all()
  end

  def symbols do
    Ecto.Query.from(
      p in "products",
      order_by: [asc: :symbol],
      select: [:symbol]
    )
    |> Repo.all()
  end

  def search(query) do
    Ecto.Query.from(
      p in "products",
      order_by: [asc: :symbol, asc: :venue, asc: :type],
      select: [:id, :symbol, :venue_symbol, :venue, :type],
      where: ilike(p.symbol, ^"%#{query}%") or ilike(p.venue, ^"%#{query}%")
    )
    |> Repo.all()
  end

  def delete(id) when is_number(id), do: %Product{id: id} |> Repo.delete()
  def delete(id) when is_bitstring(id), do: id |> String.to_integer() |> delete()
end
