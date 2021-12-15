defmodule History.OpenInterests.OpenInterestHistoryChunk do
  use Ecto.Schema
  import Ecto.Changeset
  alias History.OpenInterests

  @type id :: pos_integer
  @type t :: %__MODULE__{}

  schema "open_interest_history_chunks" do
    belongs_to(:job, OpenInterests.OpenInterestHistoryJob)
    field(:token_name, :string)
    field(:token_symbol, :string)
    field(:status, History.ChunkStatusType)

    timestamps()
  end

  @doc false
  def changeset(chunk, attrs) do
    chunk
    |> cast(attrs, [:token_name, :token_symbol, :status])
    |> validate_required([:token_name, :token_symbol, :status])
    |> assoc_constraint(:job)
    |> unique_constraint([:job, :token_symbol, :token_name])
  end
end
