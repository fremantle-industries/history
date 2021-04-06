use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
default_database_url = "postgres://postgres:postgres@localhost:5432/ghost_test?"
configured_database_url = System.get_env("DATABASE_URL") || default_database_url

database_url =
  String.replace(configured_database_url, "?", System.get_env("MIX_TEST_PARTITION", ""))

config :ghost, Ghost.Repo,
  url: database_url,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ghost, GhostWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
