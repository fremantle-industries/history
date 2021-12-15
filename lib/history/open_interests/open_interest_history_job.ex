defmodule History.OpenInterests.OpenInterestHistoryJob do
  use Ecto.Schema
  import Ecto.Changeset
  alias History.OpenInterests

  @type t :: %__MODULE__{}
  @type id :: integer

  defmodule Token do
    use Ecto.Schema
    import Ecto.Changeset

    @derive {Jason.Encoder, only: [:name, :symbol]}
    @primary_key false
    embedded_schema do
      field(:name, :string)
      field(:symbol, :string)
    end

    @doc false
    def changeset(product, attrs) do
      product
      |> cast(attrs, [:name, :symbol])
      |> validate_required([:name, :symbol])
    end
  end

  schema "open_interest_history_jobs" do
    embeds_many(:tokens, Token)
    has_many(:chunks, OpenInterests.OpenInterestHistoryChunk, foreign_key: :job_id)
    field(:status, History.JobStatusType)

    timestamps()
  end

  @doc false
  def changeset(funding_rate, attrs) do
    funding_rate
    |> cast(attrs, [:status])
    |> cast_embed(:tokens, required: true)
    |> validate_required([:status])
  end
end
