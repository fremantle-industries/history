defmodule History.Db do
  @spec db_prefix :: atom | nil
  def db_prefix do
    Application.get_env(:history, :db_prefix, nil)
  end
end
