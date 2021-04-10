defmodule Ghost.FundingRateHistoryJobs.FundingRateHistoryChunk do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ghost.FundingRateHistoryChunks.FundingRateHistoryChunkStatusType
  alias Ghost.FundingRateHistoryJobs.FundingRateHistoryJob

  schema "funding_rate_history_chunks" do
    field :venue, :string
    field :product, :string
    field :start_at, :utc_datetime
    field :end_at, :utc_datetime
    field :status, FundingRateHistoryChunkStatusType
    belongs_to :job, FundingRateHistoryJob

    timestamps()
  end

  @doc false
  def changeset(chunk, attrs) do
    chunk
    |> cast(attrs, [:venue, :product, :start_at, :end_at])
    |> validate_required([:venue, :product, :start_at, :end_at])
    |> assoc_constraint(:job)
    |> unique_constraint([:venue, :product, :job_id, :start_at, :end_at])
  end
end
