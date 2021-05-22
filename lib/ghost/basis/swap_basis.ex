defmodule Ghost.Basis.SwapBasis do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Tai.DateTime, :timestamp, []}, type: :utc_datetime_usec]

  schema "swap_basis" do
    field(:spot_venue, :string)
    field(:spot_product, :string)
    field(:swap_venue, :string)
    field(:swap_product, :string)
    field(:spread, :decimal)
    field(:spread_apr, :decimal)
    field(:last_rate, :decimal)
    field(:last_rate_apr, :decimal)
    field(:predicted_rate, :decimal)
    field(:predicted_rate_apr, :decimal)

    timestamps()
  end

  @doc false
  def changeset(chunk, attrs) do
    chunk
    |> cast(attrs, [
      :spot_venue,
      :spot_product,
      :swap_venue,
      :swap_product,
      :spread,
      :spread_apr,
      :last_rate,
      :last_rate_apr,
      :predicted_rate,
      :predicted_rate_apr
    ])
    |> validate_required([:spot_venue, :spot_product, :swap_venue, :swap_product])
  end
end
