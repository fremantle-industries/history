defmodule Ghost.Tokens do
  require Ecto.Query
  alias Ghost.Repo
  alias Ghost.Tokens.Token

  def all do
    Ecto.Query.from(
      "tokens",
      order_by: [asc: :name],
      select: [:id, :name, :symbol]
    )
    |> Repo.all()
  end

  def search(query) do
    Ecto.Query.from(
      t in "tokens",
      order_by: [asc: :name],
      select: [:id, :name, :symbol],
      where: ilike(t.name, ^"%#{query}%") or ilike(t.symbol, ^"%#{query}%")
    )
    |> Repo.all()
  end

  def insert(params) do
    changeset = Token.changeset(%Token{}, params)
    Repo.insert(changeset)
  end

  def delete(id) when is_number(id), do: %Token{id: id} |> Repo.delete()
  def delete(id) when is_bitstring(id), do: id |> String.to_integer() |> delete()
end
