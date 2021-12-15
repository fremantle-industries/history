defmodule History.Shared.Services.JobSubscribeById do
  @type job_type :: String.t()
  @type job_id :: History.JobFacade.job_id
  @type error_reason :: term

  @spec call(job_type, job_id | String.t(), module) :: :ok | {:error, error_reason}
  def call(job_type, job_id, pub_sub) do
    topic = "#{job_type}_history_job:#{job_id}"
    Phoenix.PubSub.subscribe(pub_sub, topic)
  end
end
