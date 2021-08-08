defmodule History.Products.Queries.ByType do
  require Ecto.Query
  import Ecto.Query
  alias History.Products

  def call(type) do
    Products.Queries.All.call()
    |> where(type: ^type)
  end
end
