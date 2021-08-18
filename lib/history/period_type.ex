defmodule History.PeriodType do
  use EctoEnum,
    type: :period_type,
    enums: [
      :min_1,
      :min_5,
      :min_15,
      :hour_1,
      :hour_2,
      :hour_3,
      :hour_4,
      :hour_6,
      :hour_12,
      :day_1,
      :week_1,
      :month_1,
      :year_1
    ]

  def string_values do
    __MODULE__.__valid_values__()
    |> Enum.filter(fn
      v when is_binary(v) -> true
      _ -> false
    end)
  end
end
