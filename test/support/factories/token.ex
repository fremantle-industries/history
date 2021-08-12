defmodule History.Factories.Token do
  @default_token_attrs %{
    name: "Bitcoin",
    symbol: "btc"
  }

  @spec create(map) :: term
  def create(attrs) do
    merged_attrs = Map.merge(@default_token_attrs, attrs)

    %History.Tokens.Token{}
    |> History.Tokens.Token.changeset(merged_attrs)
    |> History.Repo.insert()
  end
end
