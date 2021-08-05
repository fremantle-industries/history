defmodule History.Basis.FutureBasis do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Tai.DateTime, :timestamp, []}, type: :utc_datetime_usec]

  schema "futures_basis" do
    field(:spot_venue, :string)
    field(:spot_product, :string)
    field(:future_venue, :string)
    field(:future_product, :string)
    field(:expires_at, :utc_datetime_usec)
    field(:spread, :decimal)
    field(:apr, :decimal)

    timestamps()
  end

  @doc false
  def changeset(chunk, attrs) do
    chunk
    |> cast(attrs, [
      :spot_venue,
      :spot_product,
      :future_venue,
      :future_product,
      :expires_at,
      :spread,
      :apr
    ])
    |> validate_required([:spot_venue, :spot_product, :future_venue, :future_product])
  end
end
