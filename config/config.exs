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

config :ghost,
  future_basis: [
    # 1inch
    [spot: {:ftx, :"1inchusd"}, future: {:ftx, :"1inch0625"}],
    # aave
    [spot: {:ftx, :aaveusd}, future: {:ftx, :aave0625}],
    [spot: {:ftx, :aaveusdt}, future: {:ftx, :aave0625}],
    # badger
    [spot: {:ftx, :badgerusd}, future: {:ftx, :badger0625}],
    # bal
    [spot: {:ftx, :balusd}, future: {:ftx, :bal0625}],
    [spot: {:ftx, :balusdt}, future: {:ftx, :bal0625}],
    # bch
    [spot: {:ftx, :bchusd}, future: {:ftx, :bch0625}],
    [spot: {:ftx, :bchusdt}, future: {:ftx, :bch0625}],
    # bnb
    [spot: {:ftx, :bnbusd}, future: {:ftx, :bnb0625}],
    [spot: {:ftx, :bnbusdt}, future: {:ftx, :bnb0625}],
    # btc
    [spot: {:ftx, :btcusd}, future: {:ftx, :btc0625}],
    [spot: {:ftx, :btcusd}, future: {:ftx, :btc0924}],
    [spot: {:ftx, :btcusd}, future: {:ftx, :btc1231}],
    [spot: {:ftx, :btcusdt}, future: {:ftx, :btc0625}],
    [spot: {:ftx, :btcusdt}, future: {:ftx, :btc0924}],
    [spot: {:ftx, :btcusdt}, future: {:ftx, :btc1231}],
    # btmx
    [spot: {:ftx, :btmxusd}, future: {:ftx, :btmx0625}],
    # chz
    [spot: {:ftx, :chzusd}, future: {:ftx, :chz0625}],
    [spot: {:ftx, :chzusdt}, future: {:ftx, :chz0625}],
    # comp
    [spot: {:ftx, :compusd}, future: {:ftx, :comp0625}],
    [spot: {:ftx, :compusdt}, future: {:ftx, :comp0625}],
    # doge
    [spot: {:ftx, :dogeusd}, future: {:ftx, :doge0625}],
    # eth
    [spot: {:ftx, :ethusd}, future: {:ftx, :eth0625}],
    [spot: {:ftx, :ethusd}, future: {:ftx, :eth0924}],
    [spot: {:ftx, :ethusd}, future: {:ftx, :eth1231}],
    [spot: {:ftx, :ethusdt}, future: {:ftx, :eth0625}],
    [spot: {:ftx, :ethusdt}, future: {:ftx, :eth0924}],
    [spot: {:ftx, :ethusdt}, future: {:ftx, :eth1231}],
    # link
    [spot: {:ftx, :linkusd}, future: {:ftx, :link0625}],
    [spot: {:ftx, :linkusdt}, future: {:ftx, :link0625}],
    # ltc
    [spot: {:ftx, :ltcusd}, future: {:ftx, :ltc0625}],
    [spot: {:ftx, :ltcusdt}, future: {:ftx, :ltc0625}],
    # okb
    [spot: {:ftx, :okbusd}, future: {:ftx, :okb0625}],
    # omg
    [spot: {:ftx, :omgusd}, future: {:ftx, :omg0625}],
    # reef
    [spot: {:ftx, :reefusd}, future: {:ftx, :reef0625}],
    # sol
    [spot: {:ftx, :solusd}, future: {:ftx, :sol0625}],
    # sushi
    [spot: {:ftx, :sushiusd}, future: {:ftx, :sushi0625}],
    # sxp
    [spot: {:ftx, :sxpusd}, future: {:ftx, :sxp0625}],
    [spot: {:ftx, :sxpusdt}, future: {:ftx, :sxp0625}],
    # trx
    [spot: {:ftx, :trxusd}, future: {:ftx, :trx0625}],
    [spot: {:ftx, :trxusdt}, future: {:ftx, :trx0625}],
    # uni
    [spot: {:ftx, :uniusd}, future: {:ftx, :uni0625}],
    [spot: {:ftx, :uniusdt}, future: {:ftx, :uni0625}],
    # xrp
    [spot: {:ftx, :xrpusd}, future: {:ftx, :xrp0625}],
    [spot: {:ftx, :xrpusdt}, future: {:ftx, :xrp0625}],
    # yfi
    [spot: {:ftx, :yfiusd}, future: {:ftx, :yfi0625}],
    [spot: {:ftx, :yfiusdt}, future: {:ftx, :yfi0625}],
    # waves
    [spot: {:ftx, :wavesusd}, future: {:ftx, :waves0625}]
  ]

config :ghost,
  swap_basis: [
    # 1inch
    [spot: {:ftx, :"1inchusd"}, swap: {:ftx, :"1inchperp"}],
    # aave
    [spot: {:ftx, :aaveusd}, swap: {:ftx, :aaveperp}],
    [spot: {:ftx, :aaveusdt}, swap: {:ftx, :aaveperp}],
    # alpha
    [spot: {:ftx, :alphausd}, swap: {:ftx, :alphaperp}],
    # badger
    [spot: {:ftx, :badgerusd}, swap: {:ftx, :badgerperp}],
    # bal
    [spot: {:ftx, :balusd}, swap: {:ftx, :balperp}],
    # bch
    [spot: {:ftx, :bchusd}, swap: {:ftx, :bchperp}],
    # bnb
    [spot: {:ftx, :bnbusd}, swap: {:ftx, :bnbperp}],
    # bnt
    [spot: {:ftx, :bntusd}, swap: {:ftx, :bntperp}],
    # btmx
    [spot: {:ftx, :btmxusd}, swap: {:ftx, :btmxperp}],
    # btc
    [spot: {:ftx, :btcusd}, swap: {:ftx, :btcperp}],
    [spot: {:ftx, :btcusdt}, swap: {:ftx, :btcperp}],
    # chz
    [spot: {:ftx, :chzusd}, swap: {:ftx, :chzperp}],
    [spot: {:ftx, :chzusdt}, swap: {:ftx, :chzperp}],
    # comp
    [spot: {:ftx, :compusd}, swap: {:ftx, :compperp}],
    [spot: {:ftx, :compusdt}, swap: {:ftx, :compperp}],
    # cro
    [spot: {:ftx, :crousd}, swap: {:ftx, :croperp}],
    # crv
    [spot: {:ftx, :crvusd}, swap: {:ftx, :crvperp}],
    # dent
    [spot: {:ftx, :dentusd}, swap: {:ftx, :dentperp}],
    # dodo
    [spot: {:ftx, :dodousd}, swap: {:ftx, :dodoperp}],
    # doge
    [spot: {:ftx, :dogeusd}, swap: {:ftx, :dogeperp}],
    [spot: {:ftx, :dogeusdt}, swap: {:ftx, :dogeperp}],
    # enj
    [spot: {:ftx, :enjusd}, swap: {:ftx, :enjperp}],
    # eth
    [spot: {:ftx, :ethusd}, swap: {:ftx, :ethperp}],
    [spot: {:ftx, :ethusdt}, swap: {:ftx, :ethperp}],
    # fida
    [spot: {:ftx, :fidausd}, swap: {:ftx, :fidaperp}],
    [spot: {:ftx, :fidausdt}, swap: {:ftx, :fidaperp}],
    # ftm
    [spot: {:ftx, :ftmusd}, swap: {:ftx, :ftmperp}],
    # ftt
    [spot: {:ftx, :fttusd}, swap: {:ftx, :fttperp}],
    [spot: {:ftx, :fttusdt}, swap: {:ftx, :fttperp}],
    # knc
    [spot: {:ftx, :kncusd}, swap: {:ftx, :kncperp}],
    [spot: {:ftx, :kncusdt}, swap: {:ftx, :kncperp}],
    # link
    [spot: {:ftx, :linkusd}, swap: {:ftx, :linkperp}],
    [spot: {:ftx, :linkusdt}, swap: {:ftx, :linkperp}],
    # ltc
    [spot: {:ftx, :ltcusd}, swap: {:ftx, :ltcperp}],
    [spot: {:ftx, :ltcusdt}, swap: {:ftx, :ltcperp}],
    # lrc
    [spot: {:ftx, :lrcusd}, swap: {:ftx, :lrcperp}],
    # matic
    [spot: {:ftx, :maticusd}, swap: {:ftx, :maticperp}],
    # mkr
    [spot: {:ftx, :mkrusd}, swap: {:ftx, :mkrperp}],
    [spot: {:ftx, :mkrusdt}, swap: {:ftx, :mkrperp}],
    # okb
    [spot: {:ftx, :okbusd}, swap: {:ftx, :okbperp}],
    # omg
    [spot: {:ftx, :omgusd}, swap: {:ftx, :omgperp}],
    # oxy
    [spot: {:ftx, :oxyusd}, swap: {:ftx, :oxyperp}],
    [spot: {:ftx, :oxyusdt}, swap: {:ftx, :oxyperp}],
    # ray
    [spot: {:ftx, :rayusd}, swap: {:ftx, :rayperp}],
    # reef
    [spot: {:ftx, :reefusd}, swap: {:ftx, :reefperp}],
    [spot: {:ftx, :reefusdt}, swap: {:ftx, :reefperp}],
    # rune
    [spot: {:ftx, :runeusd}, swap: {:ftx, :runeperp}],
    [spot: {:ftx, :runeusdt}, swap: {:ftx, :runeperp}],
    # skl
    [spot: {:ftx, :sklusd}, swap: {:ftx, :sklperp}],
    # snx
    [spot: {:ftx, :snxusd}, swap: {:ftx, :snxperp}],
    # srm
    [spot: {:ftx, :srmusd}, swap: {:ftx, :srmperp}],
    [spot: {:ftx, :srmusdt}, swap: {:ftx, :srmperp}],
    # sol
    [spot: {:ftx, :solusd}, swap: {:ftx, :solperp}],
    [spot: {:ftx, :solusdt}, swap: {:ftx, :solperp}],
    # storj
    [spot: {:ftx, :storjusd}, swap: {:ftx, :storjperp}],
    # sushi
    [spot: {:ftx, :sushiusd}, swap: {:ftx, :sushiperp}],
    [spot: {:ftx, :sushiusdt}, swap: {:ftx, :sushiperp}],
    # sxp
    [spot: {:ftx, :sxpusd}, swap: {:ftx, :sxpperp}],
    [spot: {:ftx, :sxpusdt}, swap: {:ftx, :sxpperp}],
    # tomo
    [spot: {:ftx, :tomousd}, swap: {:ftx, :tomoperp}],
    [spot: {:ftx, :tomousdt}, swap: {:ftx, :tomoperp}],
    # trx
    [spot: {:ftx, :trxusd}, swap: {:ftx, :trxperp}],
    [spot: {:ftx, :trxusdt}, swap: {:ftx, :trxperp}],
    # uni
    [spot: {:ftx, :uniusd}, swap: {:ftx, :uniperp}],
    [spot: {:ftx, :uniusdt}, swap: {:ftx, :uniperp}],
    # xrp
    [spot: {:ftx, :xrpusd}, swap: {:ftx, :xrpperp}],
    [spot: {:ftx, :xrpusdt}, swap: {:ftx, :xrpperp}],
    # yfi
    [spot: {:ftx, :yfiusd}, swap: {:ftx, :yfiperp}],
    [spot: {:ftx, :yfiusdt}, swap: {:ftx, :yfiperp}],
    # waves
    [spot: {:ftx, :wavesusd}, swap: {:ftx, :wavesperp}]
  ]

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
        label: "Basis",
        link: {GhostWeb.Router.Helpers, :basis_path, [GhostWeb.Endpoint, :index]}
      },
      %{
        label: "Arb",
        link: {GhostWeb.Router.Helpers, :arb_path, [GhostWeb.Endpoint, :index]}
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
        link: {WorkbenchWeb.Router.Helpers, :balance_all_url, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Grafana",
        link: "http://grafana.localhost:3000"
      },
      %{
        label: "Prometheus",
        link: "http://prometheus.localhost:9090"
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
        label: "Advisors",
        link: {WorkbenchWeb.Router.Helpers, :advisor_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Ghost",
        link: {GhostWeb.Router.Helpers, :home_url, [GhostWeb.Endpoint, :index]}
      },
      %{
        label: "Grafana",
        link: "http://grafana.localhost:3000"
      },
      %{
        label: "Prometheus",
        link: "http://prometheus.localhost:9090"
      }
    ]
  }

# Notifications
config :notified, pubsub_server: Workbench.PubSub

config :notified,
  receivers: [
    {NotifiedPhoenix.Receivers.Speech, []},
    {NotifiedPhoenix.Receivers.BrowserNotification, []}
  ]

config :notified_phoenix,
  to_list: {WorkbenchWeb.Router.Helpers, :notification_path, [WorkbenchWeb.Endpoint, :index]}

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
      # products: ~w(
      #   btc/usd

      #   eth/usd

      #   ltc/usd
      # ) |> Enum.join(" ")
      products: ~w(
        1inch/usd
        1inch-perp
        1inch-0625

        aave/usd
        aave/usdt
        aave-perp
        aave-0625

        alpha/usd
        alpha-perp

        badger/usd
        badger-perp
        badger-0625

        bal/usd
        bal/usdt
        bal-perp
        bal-0625

        bch/usd
        bch/usdt
        bch-perp
        bch-0625

        bnb/usd
        bnb/usdt
        bnb-perp
        bnb-0625

        bnt/usd
        bnt-perp

        btc/usd
        btc/usdt
        btc-perp
        btc-0625
        btc-0924
        btc-1231

        btmx/usd
        btmx-perp
        btmx-0625

        chz/usd
        chz/usdt
        chz-perp
        chz-0625

        comp/usd
        comp/usdt
        comp-perp
        comp-0625

        cro/usd
        cro-perp

        crv/usd
        crv-perp

        dent/usd
        dent-perp

        dodo/usd
        dodo-perp

        doge/usd
        doge/usdt
        doge-perp
        doge-0625

        enj/usd
        enj-perp

        eth/usd
        eth/usdt
        eth-perp
        eth-0625
        eth-0924
        eth-1231

        fida/usd
        fida/usdt
        fida-perp

        ftm/usd
        ftm-perp

        ftt/usd
        ftt/usdt
        ftt-perp

        knc/usd
        knc/usdt
        knc-perp

        link/usd
        link/usdt
        link-perp
        link-0625

        ltc/usd
        ltc/usdt
        ltc-perp
        ltc-0625

        lrc/usd
        lrc-perp

        matic/usd
        matic-perp

        mkr/usd
        mkr/usdt
        mkr-perp

        okb/usd
        okb-perp
        okb-0625

        omg/usd
        omg-perp
        omg-0625

        oxy/usd
        oxy/usdt
        oxy-perp

        ray/usd
        ray-perp

        reef/usd
        reef-perp
        reef-0625

        rune/usd
        rune/usdt
        rune-perp

        skl/usd
        skl-perp

        snx/usd
        snx-perp

        srm/usd
        srm/usdt
        srm-perp

        sol/usd
        sol/usdt
        sol-perp
        sol-0625

        storj/usd
        storj-perp

        sushi/usd
        sushi/usdt
        sushi-perp
        sushi-0625

        sxp/usd
        sxp/usdt
        sxp-perp
        sxp-0625

        tomo/usd
        tomo/usdt
        tomo-perp

        trx/usd
        trx/usdt
        trx-perp
        trx-0625

        uni/usd
        uni/usdt
        uni-perp
        uni-0625

        xrp/usd
        xrp/usdt
        xrp-perp
        xrp-0625

        yfi/usd
        yfi/usdt
        yfi-perp
        yfi-0625

        waves/usd
        waves-perp
        waves-0625
      ) |> Enum.join(" ")
    ]
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
