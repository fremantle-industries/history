defmodule History.Shared.Services.JobBroadcast do
  @type job_type :: String.t()
  @type job_id :: History.JobFacade.job_id
  @type job_status :: History.JobFacade.job_status

  @spec call(job_type, job_id, job_status, module) :: no_return
  def call(job_type, job_id, job_status, pub_sub) do
    msg = %{id: job_id, status: job_status}

    [
      "#{job_type}_history_job:#{job_id}",
      "#{job_type}_history_job:*"
    ]
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(pub_sub, topic, {topic, msg})
    end)
  end
end
