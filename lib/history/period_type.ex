defmodule History.PeriodType do
  use EctoEnum,
    type: :period_type,
    enums: [:min_1, :min_5, :min_15, :hour_1, :hour_4, :day_1, :week_1, :month_1, :year_1]
end
