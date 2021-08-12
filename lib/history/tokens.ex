defmodule History.Tokens do
  require Ecto.Query
  alias History.{Repo, Tokens}

  @type venue_and_symbol_key :: Tokens.Token.venue_and_symbol_key()
  @type token :: Tokens.Token.t()

  @spec search(String.t() | nil) :: [token]
  def search(query) do
    query
    |> Tokens.Queries.Search.call()
    |> Repo.all()
  end

  @spec by_venue_and_symbol([venue_and_symbol_key]) :: [token]
  def by_venue_and_symbol(venue_and_symbol_keys) do
    venue_and_symbol_keys
    |> Tokens.Queries.ByVenueAndSymbol.call()
    |> Repo.all()
  end

  def insert(params) do
    changeset = Tokens.Token.changeset(%Tokens.Token{}, params)
    Repo.insert(changeset)
  end

  def delete(id) when is_number(id), do: %Tokens.Token{id: id} |> Repo.delete()
  def delete(id) when is_bitstring(id), do: id |> String.to_integer() |> delete()
end
