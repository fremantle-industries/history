defmodule GhostWeb.FundingRateView do
  use GhostWeb, :view

  def products_by_group(products, opts \\ []) do
    max_products = opts[:max_products]

    products
    |> Enum.group_by(& &1.venue)
    |> Enum.map(fn {venue, venue_products} ->
      total = Enum.count(venue_products)
      symbols = venue_products |> Enum.map(& &1.symbol)

      formatted_symbols =
        if max_products != nil && total > max_products do
          display_symbols = symbols |> Enum.take(max_products)
          hidden_total = total - max_products
          "#{display_symbols |> Enum.join(", ")}... (#{hidden_total} more)"
        else
          symbols |> Enum.join(", ")
        end

      "#{venue}: #{formatted_symbols}"
    end)
    |> Enum.join(", ")
  end
end
