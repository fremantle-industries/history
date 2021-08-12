defmodule History.Tokens.Queries.ByVenueAndSymbol do
  require Ecto.Query
  import Ecto.Query
  alias History.{Products, Tokens}

  @type key :: Tokens.Token.venue_and_symbol_key()

  @spec call([key]) :: Ecto.Query.t()
  def call(token_keys) do
    filter = filter_tokens(token_keys)

    from(
      t in Tokens.Token,
      join: p in Products.Product,
      on: p.base == t.symbol or p.quote == t.symbol,
      group_by: [t.symbol, p.venue],
      order_by: [asc: t.symbol, asc: p.venue],
      select: %{venue: p.venue, symbol: t.symbol},
      where: ^filter
    )
    |> where([t, p], p.type == "spot")
  end

  defp filter_tokens(token_keys) do
    token_keys
    |> Enum.reduce(
      dynamic(false),
      fn
        {"*", "*"}, acc ->
          dynamic([], ^acc or true)

        {venue, "*"}, acc ->
          dynamic([t, p], ^acc or p.venue == ^venue)

        {"*", symbol}, acc ->
          dynamic([t], ^acc or t.symbol == ^symbol)

        {venue, symbol}, acc ->
          dynamic([t, p], ^acc or (p.venue == ^venue and t.symbol == ^symbol))
      end
    )
  end
end
