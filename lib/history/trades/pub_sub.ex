defmodule History.Trades.PubSub do
  @topic_prefix "trade_history_job"
  def broadcast_update(job_id, status) do
    topics = ["#{@topic_prefix}:*", "#{@topic_prefix}:#{job_id}"]
    msg = {:trade_history_job, :update, %{id: job_id, status: status}}

    topics
    |> Enum.each(fn topic ->
      Phoenix.PubSub.broadcast(Tai.PubSub, topic, msg)
    end)
  end
end
