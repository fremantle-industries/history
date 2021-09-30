import Config

# Shared variables
env = config_env() |> Atom.to_string()
http_port = (System.get_env("HTTP_PORT") || "4000") |> String.to_integer()
workbench_host = System.get_env("WORKBENCH_HOST") || "workbench.localhost"
history_host = System.get_env("HISTORY_HOST") || "history.localhost"
grafana_host = System.get_env("GRAFANA_HOST") || "grafana.localhost"
prometheus_host = System.get_env("PROMETHEUS_HOST") || "prometheus.localhost"

# Configure your database
database_pool_size = String.to_integer(System.get_env("POOL_SIZE") || "10")
default_database_url = "postgres://postgres:postgres@localhost:5432/history_?"
configured_database_url = System.get_env("DATABASE_URL") || default_database_url
database_url = String.replace(configured_database_url, "?", env)

# History
config :history, ecto_repos: [History.Repo]

config :history, History.Repo,
  url: database_url,
  pool_size: database_pool_size

config :history, HistoryWeb.Endpoint,
  server: true,
  url: [host: history_host, port: http_port],
  render_errors: [view: HistoryWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Tai.PubSub,
  secret_key_base: "IKVflq8U85wcqXU8o9X9X1PblMh2WZ7ejOfhN9pSOOui0COkoqSQZIU5fJTGoaqO",
  live_view: [signing_salt: "qzNpEtaM"]

history_prometheus_metrics_port =
  "HISTORY_PROMETHEUS_METRICS_PORT" |> System.get_env("9569") |> String.to_integer()

config :history, :prometheus_metrics_port, history_prometheus_metrics_port

config :history,
  data_adapters: %{
    binance: History.Sources.Binance,
    bitmex: History.Sources.Bitmex,
    bybit: History.Sources.Bybit,
    gdax: History.Sources.Gdax,
    ftx: History.Sources.Ftx,
    okex: History.Sources.OkEx
  }

config :history, pipelines: %{
  # save_trades
  # save_trades: %{
  #   start_on_boot: false,
  #   markets: "*",
  #   streams: [:trade],
  #   steps: [
  #     {History.Pipelines.Steps.SaveTrades, :execute, []}
  #   ]
  # },
  # # min_1
  # build_min_1_candles_from_trades: %{
  #   start_on_boot: true,
  #   markets: "*",
  #   streams: [:trade],
  #   steps: [
  #     {History.Pipelines.Steps.BuildCandlesFromTrades, :execute, [period: :min_1]}
  #   ]
  # },
  # min_15
  # build_min_15_candles_from_trades: %{
  #   start_on_boot: true,
  #   markets: "*",
  #   streams: [:trade],
  #   steps: [
  #     {History.Pipelines.Steps.BuildCandlesFromTrades, :execute, [period: :min_15]}
  #   ]
  # },
  build_min_15_candles_from_min_1_candles: %{
    start_on_boot: true,
    markets: "*",
    streams: [
      [:candle_history_chunk, :period, :min_1]
    ],
    steps: [
      {History.Pipelines.Steps.BuildCandlesFromCandleHistoryChunks, :execute, [period: :min_15]}
    ]
  },
  # hour_1
  # build_hour_1_candles_from_trades: %{
  #   start_on_boot: true,
  #   markets: "*",
  #   streams: [:trade],
  #   steps: [
  #     {History.Pipelines.Steps.BuildCandlesFromTrades, :execute, [period: :hour_1]}
  #   ]
  # },
  build_hour_1_candles_from_min_1_candles: %{
    start_on_boot: true,
    markets: "*",
    streams: [
      [:candle_history_chunk, :period, :min_1]
    ],
    steps: [
      {History.Pipelines.Steps.BuildCandlesFromCandleHistoryChunks, :execute, [period: :hour_1]}
    ]
  },
  # hour_4
  # build_hour_4_candles_from_trades: %{
  #   start_on_boot: true,
  #   markets: "*",
  #   streams: [:trade],
  #   steps: [
  #     {History.Pipelines.Steps.BuildCandlesFromTrades, :execute, [period: :hour_4]}
  #   ]
  # },
  build_hour_4_candles_from_min_1_candles: %{
    start_on_boot: true,
    markets: "*",
    streams: [
      [:candle_history_chunk, :period, :min_1]
    ],
    steps: [
      {History.Pipelines.Steps.BuildCandlesFromCandleHistoryChunks, :execute, [period: :hour_4]}
    ]
  },
  # day_1
  # build_day_1_candles_from_trades: %{
  #   start_on_boot: true,
  #   markets: "*",
  #   streams: [:trade],
  #   steps: [
  #     {History.Pipelines.Steps.BuildCandlesFromTrades, :execute, [period: :day_1]}
  #   ]
  # },
  build_day_1_candles_from_min_1_candles: %{
    start_on_boot: true,
    markets: "*",
    streams: [
      [:candle_history_chunk, :period, :min_1]
    ],
    steps: [
      {History.Pipelines.Steps.BuildCandlesFromCandleHistoryChunks, :execute, [period: :day_1]}
    ]
  }
}

# Workbench
config :workbench, Workbench.Repo,
  url: database_url,
  pool_size: 10

config :workbench, WorkbenchWeb.Endpoint,
  url: [host: workbench_host, port: http_port],
  pubsub_server: Tai.PubSub,
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

# MasterProxy
config :master_proxy,
  http: [:inet6, port: http_port],
  backends: [
    %{
      host: ~r/#{history_host}/,
      phoenix_endpoint: HistoryWeb.Endpoint
    },
    %{
      host: ~r/#{workbench_host}/,
      phoenix_endpoint: WorkbenchWeb.Endpoint
    }
  ]

# Navigator
config :navigator,
  links: %{
    history: [
      %{
        label: "History",
        link: {HistoryWeb.Router.Helpers, :pipeline_path, [HistoryWeb.Endpoint, :index]},
        class: "text-4xl"
      },
      %{
        label: "Pipelines",
        link: {HistoryWeb.Router.Helpers, :pipeline_path, [HistoryWeb.Endpoint, :index]}
      },
      %{
        label: "Data",
        link: {HistoryWeb.Router.Helpers, :trade_path, [HistoryWeb.Endpoint, :index]}
      },
      %{
        label: "Products",
        link: {HistoryWeb.Router.Helpers, :product_path, [HistoryWeb.Endpoint, :index]}
      },
      %{
        label: "Tokens",
        link: {HistoryWeb.Router.Helpers, :token_path, [HistoryWeb.Endpoint, :index]}
      },
      %{
        label: "Workbench",
        link: {WorkbenchWeb.Router.Helpers, :balance_all_url, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Grafana",
        link: "http://#{grafana_host}"
      },
      %{
        label: "Prometheus",
        link: "http://#{prometheus_host}"
      }
    ],
    workbench: [
      %{
        label: "Workbench",
        link: {WorkbenchWeb.Router.Helpers, :balance_all_path, [WorkbenchWeb.Endpoint, :index]},
        class: "text-4xl"
      },
      %{
        label: "Balances",
        link: {WorkbenchWeb.Router.Helpers, :balance_day_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Accounts",
        link: {WorkbenchWeb.Router.Helpers, :account_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Wallets",
        link: {WorkbenchWeb.Router.Helpers, :wallet_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Orders",
        link: {WorkbenchWeb.Router.Helpers, :order_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Positions",
        link: {WorkbenchWeb.Router.Helpers, :position_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Products",
        link: {WorkbenchWeb.Router.Helpers, :product_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Fees",
        link: {WorkbenchWeb.Router.Helpers, :fee_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Venues",
        link: {WorkbenchWeb.Router.Helpers, :venue_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Fleets",
        link: {WorkbenchWeb.Router.Helpers, :fleet_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "History",
        link: {HistoryWeb.Router.Helpers, :trade_url, [HistoryWeb.Endpoint, :index]}
      },
      %{
        label: "Grafana",
        link: "http://#{grafana_host}"
      },
      %{
        label: "Prometheus",
        link: "http://#{prometheus_host}"
      }
    ]
  }

# Notifications
config :notified, pubsub_server: Tai.PubSub

config :notified,
  receivers: [
    {NotifiedPhoenix.Receivers.Speech, []},
    {NotifiedPhoenix.Receivers.BrowserNotification, []}
  ]

config :notified_phoenix,
  to_list: {WorkbenchWeb.Router.Helpers, :notification_path, [WorkbenchWeb.Endpoint, :index]}

# Tai
config :tai, Tai.Orders.OrderRepo,
  url: database_url,
  pool_size: 5

config :tai, fleets: %{
  recorder: %{
    advisor: History.Advisors.Recorder.Advisor,
    factory: Tai.Advisors.Factories.OnePerVenue,
    market_streams: "*"
  }
}

# Conditional Configuration
if config_env() == :dev do
  # Set a higher stacktrace during development. Avoid configuring such
  # in production as building large stacktraces may be expensive.
  config :phoenix, :stacktrace_depth, 20

  # Initialize plugs at runtime for faster development compilation
  config :phoenix, :plug_init_mode, :runtime

  # Configure your database
  config :history, History.Repo, show_sensitive_data_on_connection_error: true

  # For development, we disable any cache and enable
  # debugging and code reloading.
  #
  # The watchers configuration can be used to run external
  # watchers to your application. For example, we use it
  # with webpack to recompile .js and .css sources.
  config :history, HistoryWeb.Endpoint,
    debug_errors: true,
    code_reloader: true,
    check_origin: false,
    watchers: [
      npm: [
        "run",
        "watch",
        cd: Path.expand("../assets", __DIR__)
      ]
    ]

  # ## SSL Support
  #
  # In order to use HTTPS in development, a self-signed
  # certificate can be generated by running the following
  # Mix task:
  #
  #     mix phx.gen.cert
  #
  # Note that this task requires Erlang/OTP 20 or later.
  # Run `mix help phx.gen.cert` for more information.
  #
  # The `http:` config above can be replaced with:
  #
  #     https: [
  #       port: 4001,
  #       cipher_suite: :strong,
  #       keyfile: "priv/cert/selfsigned_key.pem",
  #       certfile: "priv/cert/selfsigned.pem"
  #     ],
  #
  # If desired, both `http:` and `https:` keys can be
  # configured to run both http and https servers on
  # different ports.

  # Watch static and templates for browser reloading.
  config :history, HistoryWeb.Endpoint,
    live_reload: [
      patterns: [
        ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
        ~r"priv/gettext/.*(po)$",
        ~r"lib/history_web/(live|views)/.*(ex)$",
        ~r"lib/history_web/templates/.*(eex)$"
      ]
    ]

  config :history, :download_candle_chunks_concurrency, {:system, :integer, "DOWNLOAD_CANDLE_CHUNKS_CONCURRENCY", 2}

  # Workbench
  config :workbench, Workbench.Repo, show_sensitive_data_on_connection_error: true

  config :workbench, WorkbenchWeb.Endpoint,
    debug_errors: true,
    check_origin: false

  # Tai
  config :tai,
    venues: %{
      binance: [
        enabled: true,
        adapter: Tai.VenueAdapters.Binance,
        timeout: 60_000,
        products: "*",
        market_streams: ""
      ],
      bitmex: [
        enabled: true,
        adapter: Tai.VenueAdapters.Bitmex,
        products: "xbtusd",
        market_streams: "*"
      ],
      bybit: [
        enabled: true,
        adapter: Tai.VenueAdapters.Bybit,
        products: "*",
        market_streams: ""
      ],
      gdax: [
        enabled: true,
        adapter: Tai.VenueAdapters.Gdax,
        products: "btc_usd",
        market_streams: ""
      ],
      ftx: [
        enabled: true,
        adapter: Tai.VenueAdapters.Ftx,
        timeout: 60_000,
        products: "*",
        market_streams: "btc-perp"
      ],
      okex: [
        enabled: true,
        adapter: Tai.VenueAdapters.OkEx,
        products: "btc_usdt eth_usdt",
        market_streams: ""
      ]
    }

  # Logger
  unless System.get_env("DOCKER") == "true" do
    level = "LOG_LEVEL" |> System.get_env("info") |> String.to_atom()
    config :logger, backends: [{LoggerFileBackend, :file_log}]
    config :logger, :file_log, path: "./logs/#{config_env()}.log", level: level
  end
end

if config_env() == :test do
  config :history, History.Repo, pool: Ecto.Adapters.SQL.Sandbox

  # We don't run a server during test. If one is required,
  # you can enable the server option below.
  config :history, HistoryWeb.Endpoint,
    http: [port: 4002],
    server: false

  # Logger
  unless System.get_env("DOCKER") == "true" do
    level = "LOG_LEVEL" |> System.get_env("warn") |> String.to_atom()
    config :logger, backends: [{LoggerFileBackend, :file_log}]
    config :logger, :file_log, path: "./logs/#{config_env()}.log", level: level
  end
end
