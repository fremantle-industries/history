defmodule History.Candles.CandleHistoryChunk do
  use Ecto.Schema
  import Ecto.Changeset
  alias History.Candles

  @type t :: %__MODULE__{}

  schema "candle_history_chunks" do
    belongs_to(:job, Candles.CandleHistoryJob)
    field(:venue, :string)
    field(:product, :string)
    field(:start_at, :utc_datetime)
    field(:end_at, :utc_datetime)
    field(:period, History.PeriodType)
    field(:status, History.ChunkStatusType)

    timestamps()
  end

  @doc false
  def changeset(chunk, attrs) do
    chunk
    |> cast(attrs, [:venue, :product, :start_at, :end_at, :period, :status])
    |> validate_required([:venue, :product, :start_at, :end_at, :period, :status])
    |> assoc_constraint(:job)
    |> unique_constraint([:venue, :product, :job_id, :start_at, :end_at, :period])
  end
end
