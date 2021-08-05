defmodule History.Products.Services.Import do
  require Ecto.Query
  alias History.Repo
  alias History.Products.Product

  def call do
    Tai.Venues.ProductStore.all()
    |> Enum.map(fn tai_product ->
      venue = tai_product.venue_id |> Atom.to_string()
      symbol = tai_product.symbol |> Atom.to_string()
      type = tai_product.type |> Atom.to_string()
      base = tai_product.base |> Atom.to_string()
      quote = tai_product.quote |> Atom.to_string()

      case History.Repo.one(
             Ecto.Query.from(p in Product,
               where: p.venue == ^venue and p.symbol == ^symbol and p.type == ^type
             )
           ) do
        nil ->
          %Product{
            venue: venue,
            symbol: symbol,
            venue_symbol: tai_product.venue_symbol,
            base: base,
            quote: quote,
            type: type
          }

        product ->
          product
      end
    end)
    |> Enum.map(&Product.changeset(&1, %{}))
    |> Enum.each(&Repo.insert_or_update!/1)
  end
end
