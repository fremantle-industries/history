defmodule History.Pipelines.Instance do
  @enforce_keys ~w[id status streams steps]a
  defstruct ~w[id pid status streams steps]a

  def whereis(id) do
    id
    |> History.Pipelines.Pipeline.process_name()
    |> Process.whereis()
  end
end
