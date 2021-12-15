defmodule History.OpenInterests.Queries.SearchLatest do
  # require Ecto.Query
  # import Ecto.Query
  alias History.{Shared, OpenInterests.OpenInterest}

  def query(opts \\ []) do
    # search_query = opts[:query]
    query = Shared.Queries.Latest.call(OpenInterest, opts)

    # query =
    #   if search_query do
    #     where(
    #       query,
    #       [r],
    #       ilike(r.venue, ^"%#{search_query}%") or ilike(r.product, ^"%#{search_query}%")
    #     )
    #   else
    #     query
    #   end

    query
  end
end
