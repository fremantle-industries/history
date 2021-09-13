defmodule History.JobSchedules do
  require Logger

  @type loaded_job_schedules :: non_neg_integer()

  @spec load :: {:ok, loaded_job_schedules}
  def load do
    Logger.warn "!!!!!!! TODO: Load job schedules as quantum jobs"

    # {:ok, loaded_trades} = load_trades()
    # {:ok, loaded_candles} = load_candles()
    # {:ok, loaded_funding_rates} = load_funding_rates()
    {:ok, loaded_predicted_funding_rates} = load_predicted_funding_rates()
    # {:ok, loaded_lending_rates} = load_lending_rates()

    loaded_total = loaded_predicted_funding_rates

    {:ok, loaded_total}
  end

  def load_predicted_funding_rates do
    {:ok, 0}
  end
end
