defmodule GhostWeb.Router do
  use GhostWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GhostWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GhostWeb do
    pipe_through :browser

    live "/", HomeLive, :index
    live "/basis", BasisLive, :index
    live "/basis/futures", BasisFutureLive, :index
    live "/basis/swap", BasisSwapLive, :index
    live "/arb", ArbLive, :index
    live "/predictions", PredictionLive, :index
    live "/data", DataLive, :index
    live "/data/ohlc", OHLCLive, :index
    live "/data/predicted_funding", PredictedFundingRateLive, :index
    live "/data/funding", FundingRateLive, :index
    live "/data/funding/latest", FundingRateLatestLive, :index
    live "/data/funding/jobs", FundingRateJob.IndexLive, :index, as: :funding_rate_job
    live "/data/funding/jobs/:id", FundingRateJob.ShowLive, :show, as: :funding_rate_job
    live "/data/lending", LendingRateLive, :index
    live "/data/lending/latest", LendingRateLatestLive, :index
    live "/data/lending/jobs", LendingRateJob.IndexLive, :index, as: :lending_rate_job
    live "/data/lending/jobs/:id", LendingRateJob.ShowLive, :show, as: :lending_rate_job
    live "/products", ProductLive, :index
    live "/tokens", TokenLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", GhostWeb do
  #   pipe_through :api
  # end

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
      pipe_through :browser
      live_dashboard "/dashboard", metrics: GhostWeb.Telemetry
    end
  end
end
