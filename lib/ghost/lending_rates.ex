defmodule Ghost.LendingRates do
  require Ecto.Query
  alias Ghost.Repo
  alias Ghost.LendingRates.LendingRate

  def all do
    Ecto.Query.from(
      "lending_rates",
      order_by: [asc: :time, asc: :product, asc: :venue],
      select: [:id, :time, :product, :venue, :rate]
    )
    |> Repo.all()
  end

  def delete(id) when is_number(id), do: %LendingRate{id: id} |> Repo.delete()
  def delete(id) when is_bitstring(id), do: id |> String.to_integer() |> delete()
end
