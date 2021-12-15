defmodule History.Sources.Ftx.OpenInterests do
  def fetch(_chunk) do
    # start_time = DateTime.to_unix(chunk.start_at)
    # end_time = DateTime.to_unix(chunk.end_at)
    # coin = String.upcase(chunk.token)
    # params = %{coin: coin, start_time: start_time, end_time: end_time}
    # ExFtx.SpotMargin.LendingHistory.get(params)

    {:ok, []}
  end
end
