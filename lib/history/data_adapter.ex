defmodule History.DataAdapter do
  @type venue :: String.t() | atom
  @type adapter_type ::
          :trades
          | :candles
          | :liquidations
          | :funding_rates
          | :predicted_funding_rates
          | :lending_rates
  @type for_venue_error_reason :: :venue_adapter_not_found | :adapter_type_not_found

  @callback trades() :: module
  @callback candles() :: module
  @callback liquidations() :: module
  @callback funding_rates() :: module
  @callback predicted_funding_rates() :: module
  @callback lending_rates() :: module

  @spec for_venue(venue, adapter_type) :: {:ok, module} | {:error, for_venue_error_reason}
  def for_venue(venue, adapter_type) do
    with {:ok, venue_adapter} <- venue_adapter(venue) do
      case apply(venue_adapter, adapter_type, []) do
        nil -> {:error, :adapter_type_not_found}
        venue_adapter_type -> {:ok, venue_adapter_type}
      end
    end
  end

  defp venue_adapter(venue) do
    adapters = data_adapters()

    case adapters[venue] do
      nil -> {:error, :venue_adapter_not_found}
      data_adapter -> {:ok, data_adapter}
    end
  end

  defp data_adapters do
    :history
    |> Application.get_env(:data_adapters, %{})
    |> Indifferent.access()
  end
end
