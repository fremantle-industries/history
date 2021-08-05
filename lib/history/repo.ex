defmodule History.Repo do
  @otp_app Mix.Project.config()[:app]
  use Ecto.Repo, otp_app: @otp_app, adapter: Ecto.Adapters.Postgres
end
