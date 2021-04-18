defmodule Ghost.LendingRateHistoryJobs.CreateChunksProducer do
  use GenStage
  alias Ghost.LendingRateHistoryJobs

  @behaviour Broadway.Producer

  defmodule State do
    @type t :: %State{
            demand: non_neg_integer,
            last_job_id: non_neg_integer,
            receive_interval: non_neg_integer,
            receive_timer: reference | nil
          }

    defstruct ~w[demand last_job_id receive_interval receive_timer]a
  end

  @default_last_job_id 0
  @default_receive_interval 5000

  @impl true
  def init(opts) do
    last_job_id = opts[:last_job_id] || @default_last_job_id
    receive_interval = opts[:receive_interval] || @default_receive_interval
    state = %State{demand: 0, last_job_id: last_job_id, receive_interval: receive_interval}
    {:producer, state}
  end

  @impl true
  def handle_demand(incoming_demand, state) do
    handle_receive_messages(%{state | demand: state.demand + incoming_demand})
  end

  @impl true
  def handle_info(:receive_messages, %_{receive_timer: nil} = state) do
    {:noreply, [], state}
  end

  @impl true
  def handle_info(:receive_messages, state) do
    handle_receive_messages(%{state | receive_timer: nil})
  end

  defp handle_receive_messages(%_{receive_timer: nil, demand: demand} = state) when demand > 0 do
    jobs = LendingRateHistoryJobs.enqueued_after(state.last_job_id, demand)
    last_job = List.last(jobs)
    last_job_id_cursor = if last_job, do: last_job.id, else: state.last_job_id
    new_demand = demand - length(jobs)

    receive_timer =
      case {jobs, new_demand} do
        {[], _} -> schedule_receive_messages(state.receive_interval)
        {_, 0} -> nil
        _ -> schedule_receive_messages(0)
      end

    state = %{
      state
      | demand: new_demand,
        receive_timer: receive_timer,
        last_job_id: last_job_id_cursor
    }

    {:noreply, jobs, state}
  end

  defp handle_receive_messages(state) do
    {:noreply, [], state}
  end

  defp schedule_receive_messages(interval) do
    Process.send_after(self(), :receive_messages, interval)
  end
end
