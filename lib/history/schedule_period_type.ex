defmodule History.SchedulePeriodType do
  use EctoEnum,
    type: :schedule_period_type,
    enums: [
      :min,
      :hour,
      :day
    ]

  def string_values do
    __MODULE__.__valid_values__()
    |> Enum.filter(fn
      v when is_binary(v) -> true
      _ -> false
    end)
  end
end
