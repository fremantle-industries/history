defmodule Ghost.PredictedFundingRates.PredictedFundingRateChunk do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ghost.PredictedFundingRates.PredictedFundingRateJob

  schema "predicted_funding_rate_chunks" do
    field :venue, :string
    field :product, :string
    field :status, Ghost.ChunkStatusType
    belongs_to :job, PredictedFundingRateJob

    timestamps()
  end

  @doc false
  def changeset(chunk, attrs) do
    chunk
    |> cast(attrs, [:venue, :product, :status])
    |> validate_required([:venue, :product, :status])
    |> assoc_constraint(:job)
    |> unique_constraint([:venue, :product, :job_id])
  end
end
