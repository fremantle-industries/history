defmodule History.Shared.Queries.Latest do
  require Indifferent
  require Ecto.Query
  import Ecto.Query

  @type opts :: %{
    optional(:page) => non_neg_integer,
    optional(:page_size) => non_neg_integer
  }
  @type schema :: struct
  @type schema_type :: module

  @default_latest_page 1
  @default_latest_page_size 25
  @max_page_size 100

  @spec call(schema_type, [opts]) :: Ecto.Query.t()
  def call(schema_type, opts) do
    page = max((opts[:page] || @default_latest_page) - 1, 0)
    page_size = min(opts[:page_size] || @default_latest_page_size, @max_page_size)
    offset = page * page_size

    from(
      schema_type,
      order_by: [desc: :inserted_at],
      offset: ^offset,
      limit: ^page_size
    )
  end
end
