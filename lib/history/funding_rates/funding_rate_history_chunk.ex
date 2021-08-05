defmodule History.FundingRates.FundingRateHistoryChunk do
  use Ecto.Schema
  import Ecto.Changeset
  alias History.FundingRates

  schema "funding_rate_history_chunks" do
    field(:venue, :string)
    field(:product, :string)
    field(:start_at, :utc_datetime)
    field(:end_at, :utc_datetime)
    field(:status, History.ChunkStatusType)
    belongs_to(:job, FundingRates.FundingRateHistoryJob)

    timestamps()
  end

  @doc false
  def changeset(chunk, attrs) do
    chunk
    |> cast(attrs, [:venue, :product, :start_at, :end_at, :status])
    |> validate_required([:venue, :product, :start_at, :end_at, :status])
    |> assoc_constraint(:job)
    |> unique_constraint([:venue, :product, :job_id, :start_at, :end_at])
  end
end
