defmodule Ghost.LendingRateHistoryDownloads.LendingRateHistoryDownload do
  use Ecto.Schema
  import Ecto.Changeset

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

  schema "lending_rate_history_downloads" do
    field :from_date, :date
    field :from_time, :time
    field :to_date, :date
    field :to_time, :time
    embeds_many :products, Product

    timestamps()
  end

  @doc false
  def changeset(lending_rate, attrs) do
    lending_rate
    |> cast(attrs, [:from_date, :from_time, :to_date, :to_time])
    |> cast_embed(:products, required: true)
    |> validate_required([:from_date, :from_time, :to_date, :to_time, :products])
  end

  def from(lending_rate) do
    DateTime.new(lending_rate.from_date, lending_rate.from_time)
  end

  def to(lending_rate) do
    DateTime.new(lending_rate.to_date, lending_rate.to_time)
  end
end
