defmodule Mix.Tasks.History.Seed do
  use Mix.Task

  def run(_) do
    Mix.Task.run("app.start", [])
    seed(Mix.env())
  end

  def seed(:test) do
    # no-op
  end

  def seed(_) do
    Code.require_file("../../../priv/repo/seeds/tokens.exs", __DIR__)
  end
end
