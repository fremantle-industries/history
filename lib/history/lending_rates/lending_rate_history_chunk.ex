defmodule History.LendingRates.LendingRateHistoryChunk do
  use Ecto.Schema
  import Ecto.Changeset
  alias History.LendingRates

  schema "lending_rate_history_chunks" do
    field(:venue, :string)
    field(:token, :string)
    field(:start_at, :utc_datetime)
    field(:end_at, :utc_datetime)
    field(:status, History.ChunkStatusType)
    belongs_to(:job, LendingRates.LendingRateHistoryJob)

    timestamps()
  end

  @doc false
  def changeset(chunk, attrs) do
    chunk
    |> cast(attrs, [:venue, :token, :start_at, :end_at, :status])
    |> validate_required([:venue, :token, :start_at, :end_at, :status])
    |> assoc_constraint(:job)
    |> unique_constraint([:venue, :product, :job_id, :start_at, :end_at])
  end
end
