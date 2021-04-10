# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

http_port = "PORT" |> System.get_env("4000") |> String.to_integer()

# Configure your database
database_pool_size = String.to_integer(System.get_env("POOL_SIZE") || "10")
default_database_url = "postgres://postgres:postgres@localhost:5432/ghost_?"
configured_database_url = System.get_env("DATABASE_URL") || default_database_url
database_url = String.replace(configured_database_url, "?", "dev")

# Ghost
config :ghost, ecto_repos: [Ghost.Repo]

config :ghost, Ghost.Repo,
  url: database_url,
  pool_size: database_pool_size

config :ghost, GhostWeb.Endpoint,
  server: true,
  url: [host: "ghost.localhost", port: http_port],
  render_errors: [view: GhostWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Ghost.PubSub,
  secret_key_base: "IKVflq8U85wcqXU8o9X9X1PblMh2WZ7ejOfhN9pSOOui0COkoqSQZIU5fJTGoaqO",
  live_view: [signing_salt: "qzNpEtaM"]

ghost_prometheus_metrics_port =
  "GHOST_PROMETHEUS_METRICS_PORT" |> System.get_env("9569") |> String.to_integer()

config :ghost, :prometheus_metrics_port, ghost_prometheus_metrics_port

# TODO: Build token list from tai products
# config :ghost,
#   token_providers: %{
#     tai: {Ghost.TokenProviders.Tai, :fetch, []}
#   }
config :ghost,
  data_adapters: %{
    ftx: Ghost.DataAdapters.Ftx,
    binance: Ghost.DataAdapters.Binance
  }

# Workbench
config :workbench, Workbench.Repo,
  url: database_url,
  pool_size: 10

config :workbench, WorkbenchWeb.Endpoint,
  url: [host: "workbench.localhost", port: http_port],
  pubsub_server: Workbench.PubSub,
  live_view: [signing_salt: "3kcyIROlwEycfF3Ea+Y33dH+g2S5pg4c"],
  secret_key_base: "fZUpnPa+1UWIZw8eHVLDMuB7+hYyvxJVYu9+LZpQCrpon/kWUjp5b2Eehz03dQ4t",
  server: false

workbench_prometheus_metrics_port =
  "WORKBENCH_PROMETHEUS_METRICS_PORT" |> System.get_env("9568") |> String.to_integer()

config :workbench, :prometheus_metrics_port, workbench_prometheus_metrics_port

config :workbench,
  asset_aliases: %{
    btc: [:xbt],
    usd: [:busd, :pax, :usdc, :usdt, :tusd]
  },
  balance_snapshot: %{
    enabled: {:system, :boolean, "BALANCE_SNAPSHOT_ENABLED", false},
    boot_delay_ms: {:system, :integer, "BALANCE_SNAPSHOT_BOOT_DELAY_MS", 10_000},
    every_ms: {:system, :integer, "BALANCE_SNAPSHOT_EVERY_MS", 60_000},
    btc_usd_venue: {:system, :atom, "BALANCE_SNAPSHOT_BTC_USD_VENUE", :binance},
    btc_usd_symbol: {:system, :atom, "BALANCE_SNAPSHOT_BTC_USD_SYMBOL", :btc_usdc},
    usd_quote_venue: {:system, :atom, "BALANCE_SNAPSHOT_USD_QUOTE_VENUE", :binance},
    usd_quote_asset: {:system, :atom, "BALANCE_SNAPSHOT_USD_QUOTE_ASSET", :usdt},
    quote_pairs: [binance: :usdt, okex: :usdt]
  }

# Shared
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :master_proxy,
  http: [:inet6, port: http_port],
  backends: [
    %{
      host: ~r/ghost.localhost/,
      phoenix_endpoint: GhostWeb.Endpoint
    },
    %{
      host: ~r/workbench.localhost/,
      phoenix_endpoint: WorkbenchWeb.Endpoint
    }
  ]

config :navigator,
  links: %{
    ghost: [
      %{
        label: "Ghost",
        link: {GhostWeb.Router.Helpers, :home_path, [GhostWeb.Endpoint, :index]},
        class: "text-4xl"
      },
      %{
        label: "Predictions",
        link: {GhostWeb.Router.Helpers, :prediction_path, [GhostWeb.Endpoint, :index]}
      },
      %{
        label: "Data",
        link: {GhostWeb.Router.Helpers, :data_path, [GhostWeb.Endpoint, :index]}
      },
      %{
        label: "Products",
        link: {GhostWeb.Router.Helpers, :product_path, [GhostWeb.Endpoint, :index]}
      },
      %{
        label: "Tokens",
        link: {GhostWeb.Router.Helpers, :token_path, [GhostWeb.Endpoint, :index]}
      },
      %{
        label: "Workbench",
        link:
          {WorkbenchWeb.Router.Helpers, :live_url,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.BalanceAllLive.Index]}
      }
    ],
    workbench: [
      %{
        label: "Workbench",
        link:
          {WorkbenchWeb.Router.Helpers, :balance_config_path, [WorkbenchWeb.Endpoint, :index]},
        class: "text-4xl"
      },
      %{
        label: "Balances",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.BalanceAllLive.Index]}
      },
      %{
        label: "Accounts",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.AccountLive.Index]}
      },
      %{
        label: "Wallets",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.WalletLive.Index]}
      },
      %{
        label: "Orders",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.OrderLive.Index]}
      },
      %{
        label: "Positions",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.PositionLive.Index]}
      },
      %{
        label: "Products",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.ProductLive.Index]}
      },
      %{
        label: "Fees",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.FeeLive.Index]}
      },
      %{
        label: "Venues",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.VenueLive.Index]}
      },
      %{
        label: "Advisors",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.AdvisorLive.Index]}
      },
      %{
        label: "Ghost",
        link: {GhostWeb.Router.Helpers, :home_url, [GhostWeb.Endpoint, :index]}
      }
    ]
  }

# Tai
config :tai,
  venues: %{
    binance: [
      enabled: true,
      adapter: Tai.VenueAdapters.Binance,
      timeout: 60_000,
      products: ~w(
        btc_usdc
        btc_usdt
        btc_busd
        btc_tusd

        dot_usdt
        eth_usdt
        ltc_usdt
        link_usdt
        sol_usdt
      ) |> Enum.join(" ")
    ],
    ftx: [
      enabled: true,
      adapter: Tai.VenueAdapters.Ftx,
      timeout: 60_000,
      products: ~w(
        btc/usd

        eth/usd

        ltc/usd
      ) |> Enum.join(" ")
    ]
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
