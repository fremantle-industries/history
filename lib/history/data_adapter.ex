defmodule History.DataAdapter do
  @callback trades() :: module
  @callback liquidations() :: module
  @callback funding_rates() :: module
  @callback predicted_funding_rates() :: module
  @callback lending_rates() :: module

  @spec for_venue(atom | String.t()) :: {:ok, module} | {:error, :not_found}
  def for_venue(venue) do
    adapters = :history |> Application.get_env(:data_adapters, %{}) |> Indifferent.access()

    case adapters[venue] do
      nil -> {:error, :not_found}
      adapter -> {:ok, adapter}
    end
  end
end
