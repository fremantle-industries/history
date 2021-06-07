defmodule Ghost.PredictedFundingRates.PubSub do
  @topic_prefix "predicted_funding_rate_job"
  def broadcast_update(job_id, status) do
    topics = ["#{@topic_prefix}:*", "#{@topic_prefix}:#{job_id}"]
    msg = {:predicted_funding_rate_job, :update, %{id: job_id, status: status}}

    topics
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(Ghost.PubSub, topic, msg)
    end)
  end
end
