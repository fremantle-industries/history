defmodule History.DataAdapter do
  @callback trades() :: module
  @callback liquidations() :: module
  @callback funding_rates() :: module
  @callback predicted_funding_rates() :: module
  @callback lending_rates() :: module
end
