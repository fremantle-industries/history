defmodule HistoryWeb.Router do
  use HistoryWeb, :router
  import Redirect

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {HistoryWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  redirect("/", "/data/trade", :permanent)
  redirect("/data", "/data/trade", :permanent)

  scope "/", HistoryWeb do
    pipe_through(:browser)

    live("/data/trade", TradeLive, :index)
    live("/data/trade/latest", TradeLatestLive, :index)
    live("/data/trade/jobs", TradeJob.IndexLive, :index, as: :trade_job)
    live("/data/trade/jobs/:id", TradeJob.ShowLive, :show, as: :trade_job)
    live("/data/candles", CandleLive, :index)
    live("/data/candles/latest", CandleLatestLive, :index)
    live("/data/candles/jobs", CandleJob.IndexLive, :index, as: :candle_job)
    live("/data/candles/jobs/:id", CandleJob.ShowLive, :show, as: :candle_job)
    live("/data/predicted_funding", PredictedFundingRateLive, :index)

    live("/data/predicted_funding/jobs", PredictedFundingRateJob.IndexLive, :index,
      as: :predicted_funding_rate_job
    )

    live("/data/predicted_funding/jobs/:id", PredictedFundingRateJob.ShowLive, :show,
      as: :predicted_funding_rate_job
    )

    live("/data/funding", FundingRateLive, :index)
    live("/data/funding/latest", FundingRateLatestLive, :index)
    live("/data/funding/jobs", FundingRateJob.IndexLive, :index, as: :funding_rate_job)
    live("/data/funding/jobs/:id", FundingRateJob.ShowLive, :show, as: :funding_rate_job)
    live("/data/lending", LendingRateLive, :index)
    live("/data/lending/latest", LendingRateLatestLive, :index)
    live("/data/lending/jobs", LendingRateJob.IndexLive, :index, as: :lending_rate_job)
    live("/data/lending/jobs/:id", LendingRateJob.ShowLive, :show, as: :lending_rate_job)
    live("/products", ProductLive, :index)
    live("/tokens", TokenLive, :index)
  end

  scope "/", NotifiedPhoenix do
    pipe_through(:browser)

    live("/notifications", ListLive, :index,
      as: :notification,
      layout: {HistoryWeb.LayoutView, :root}
    )
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: HistoryWeb.Telemetry)
    end
  end
end
