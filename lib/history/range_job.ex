defprotocol History.RangeJob do
  @type t :: struct
  @type date_time_result ::
          {:ok, DateTime.t()}
          | {:ambiguous, first_datetime :: t(), second_datetime :: t()}
          | {:gap, t(), t()}
          | {:error,
             :incompatible_calendars
             | :time_zone_not_found
             | :utc_only_time_zone_database}

  @spec from(t) :: date_time_result
  def from(job)

  @spec to(t) :: date_time_result
  def to(job)

  @spec from!(t) :: DateTime.t()
  def from!(job)

  @spec to!(t) :: DateTime.t()
  def to!(job)
end
