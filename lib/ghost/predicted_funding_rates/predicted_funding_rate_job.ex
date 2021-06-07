defmodule Ghost.PredictedFundingRates.PredictedFundingRateJob do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ghost.PredictedFundingRates.PredictedFundingRateChunk

  defmodule Product do
    use Ecto.Schema
    import Ecto.Changeset

    @derive {Jason.Encoder, only: [:venue, :symbol]}
    @primary_key false
    embedded_schema do
      field :venue, :string
      field :symbol, :string
    end

    @doc false
    def changeset(product, attrs) do
      product
      |> cast(attrs, [:venue, :symbol])
      |> validate_required([:venue, :symbol])
    end
  end

  schema "predicted_funding_rate_jobs" do
    field :status, Ghost.JobStatusType
    embeds_many :products, Product
    has_many :chunks, PredictedFundingRateChunk, foreign_key: :job_id

    timestamps()
  end

  @doc false
  def changeset(funding_rate, attrs) do
    funding_rate
    |> cast(attrs, [:status])
    |> cast_embed(:products, required: true)
    |> validate_required([:status, :products])
  end
end
