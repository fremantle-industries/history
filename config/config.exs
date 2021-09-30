import Config

# Tai can't switch adapters at runtime
config :tai, order_repo_adapter: Ecto.Adapters.Postgres

# Ecto_repos can't be detected in runtime.exs
# config :history, ecto_repos: [Tai.Orders.OrderRepo, History.Repo]
config :history, ecto_repos: [History.Repo]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
