defmodule Ghost.FundingRates do
  require Ecto.Query
  alias Ghost.Repo
  alias Ghost.FundingRates.FundingRate

  def all do
    Ecto.Query.from(
      "funding_rates",
      order_by: [asc: :time, asc: :product, asc: :venue],
      select: [:id, :time, :product, :venue, :rate]
    )
    |> Repo.all()
  end

  def delete(id) when is_number(id), do: %FundingRate{id: id} |> Repo.delete()
  def delete(id) when is_bitstring(id), do: id |> String.to_integer() |> delete()
end
