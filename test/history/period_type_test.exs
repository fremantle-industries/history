defmodule History.PeriodTypeTest do
  use ExUnit.Case
  doctest History.PeriodType

  test ".atom_values/0" do
    assert History.PeriodType.string_values() == [
             "min_1",
             "min_5",
             "min_15",
             "hour_1",
             "hour_2",
             "hour_3",
             "hour_4",
             "hour_6",
             "hour_12",
             "day_1",
             "week_1",
             "month_1",
             "year_1"
           ]
  end
end
