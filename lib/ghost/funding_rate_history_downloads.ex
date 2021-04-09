defmodule Ghost.FundingRateHistoryDownloads do
  require Ecto.Query
  alias Ghost.Repo
  alias Ghost.FundingRateHistoryDownloads.FundingRateHistoryDownload

  def all do
    FundingRateHistoryDownload
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

    FundingRateHistoryDownload.changeset(%FundingRateHistoryDownload{}, merged_params)
  end

  def insert(params) do
    changeset = FundingRateHistoryDownload.changeset(%FundingRateHistoryDownload{}, params)
    Repo.insert(changeset)
  end
end
