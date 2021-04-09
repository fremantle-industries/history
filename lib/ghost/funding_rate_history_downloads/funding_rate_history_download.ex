defmodule Ghost.FundingRateHistoryDownloads.FundingRateHistoryDownload do
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

  schema "funding_rate_history_downloads" do
    field :from_date, :date
    field :from_time, :time
    field :to_date, :date
    field :to_time, :time
    embeds_many :products, Product

    timestamps()
  end

  @doc false
  def changeset(funding_rate, attrs) do
    funding_rate
    |> cast(attrs, [:from_date, :from_time, :to_date, :to_time])
    |> cast_embed(:products, required: true)
    |> validate_required([:from_date, :from_time, :to_date, :to_time, :products])
  end

  def from(funding_rate) do
    DateTime.new(funding_rate.from_date, funding_rate.from_time)
  end

  def to(funding_rate) do
    DateTime.new(funding_rate.to_date, funding_rate.to_time)
  end
end
