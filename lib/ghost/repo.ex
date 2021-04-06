defmodule Ghost.Repo do
  use Ecto.Repo,
    otp_app: :ghost,
    adapter: Ecto.Adapters.Postgres
end
