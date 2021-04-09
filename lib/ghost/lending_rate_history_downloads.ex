defmodule Ghost.LendingRateHistoryDownloads do
  require Ecto.Query
  alias Ghost.Repo
  alias Ghost.LendingRateHistoryDownloads.LendingRateHistoryDownload

  def all do
    LendingRateHistoryDownload
    |> Ecto.Query.order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def changeset_today(params) do
    today = Date.utc_today()
    tomorrow = Date.utc_today() |> Timex.shift(days: 1)
    start_of_day = Time.new!(0, 0, 0)

    merged_params =
      Map.merge(
        params,
        %{
          from_date: today,
          from_time: start_of_day,
          to_date: tomorrow,
          to_time: start_of_day
        }
      )

    LendingRateHistoryDownload.changeset(%LendingRateHistoryDownload{}, merged_params)
  end

  def insert(params) do
    changeset = LendingRateHistoryDownload.changeset(%LendingRateHistoryDownload{}, params)
    Repo.insert(changeset)
  end
end
