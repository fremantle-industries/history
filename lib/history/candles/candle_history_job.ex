defmodule History.Candles.CandleHistoryJob do
  use Ecto.Schema
  import Ecto.Changeset
  alias History.Candles

  @type t :: %__MODULE__{}
  @type id :: integer

  defmodule Product do
    use Ecto.Schema
    import Ecto.Changeset

    @derive {Jason.Encoder, only: [:venue, :symbol]}
    @primary_key false
    embedded_schema do
      field(:venue, :string)
      field(:symbol, :string)
    end

    @doc false
    def changeset(product, attrs) do
      product
      |> cast(attrs, [:venue, :symbol])
      |> validate_required([:venue, :symbol])
    end
  end

  schema "candle_history_jobs" do
    field(:from_date, :date)
    field(:from_time, :time)
    field(:to_date, :date)
    field(:to_time, :time)
    field(:periods, {:array, History.PeriodType})
    embeds_many(:products, Product)
    has_many(:chunks, Candles.CandleHistoryChunk, foreign_key: :job_id)
    field(:status, History.JobStatusType)

    timestamps()
  end

  @doc false
  def changeset(funding_rate, attrs) do
    funding_rate
    |> cast(attrs, [:from_date, :from_time, :to_date, :to_time, :periods, :status])
    |> cast_embed(:products, required: true)
    |> validate_required([
      :from_date,
      :from_time,
      :to_date,
      :to_time,
      :periods,
      :products,
      :status
    ])
  end

  defimpl History.RangeJob do
    def from(job) do
      DateTime.new(job.from_date, job.from_time)
    end

    def to(job) do
      DateTime.new(job.to_date, job.to_time)
    end

    def from!(job) do
      DateTime.new!(job.from_date, job.from_time)
    end

    def to!(job) do
      DateTime.new!(job.to_date, job.to_time)
    end
  end
end
