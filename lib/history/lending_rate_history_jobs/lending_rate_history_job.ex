defmodule History.LendingRateHistoryJobs.LendingRateHistoryJob do
  use Ecto.Schema
  import Ecto.Changeset
  alias History.LendingRateHistoryJobs.LendingRateHistoryJobStatusType

  defmodule Token do
    use Ecto.Schema
    import Ecto.Changeset

    @derive {Jason.Encoder, only: [:venue, :symbol]}
    @primary_key false
    embedded_schema do
      field(:venue, :string)
      field(:symbol, :string)
    end

    @doc false
    def changeset(token, attrs) do
      token
      |> cast(attrs, [:venue, :symbol])
      |> validate_required([:venue, :symbol])
    end
  end

  schema "lending_rate_history_jobs" do
    field(:from_date, :date)
    field(:from_time, :time)
    field(:to_date, :date)
    field(:to_time, :time)
    field(:status, LendingRateHistoryJobStatusType)
    embeds_many(:tokens, Token)

    timestamps()
  end

  @doc false
  def changeset(lending_rate, attrs) do
    lending_rate
    |> cast(attrs, [:from_date, :from_time, :to_date, :to_time, :status])
    |> cast_embed(:tokens, required: true)
    |> validate_required([:from_date, :from_time, :to_date, :to_time, :status, :tokens])
  end

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
