# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# tai can't switch adapters at runtime
config :tai, order_repo_adapter: Ecto.Adapters.Postgres

# ecto_repos can't be detected in runtime.exs
config :history, ecto_repos: [History.Repo]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
