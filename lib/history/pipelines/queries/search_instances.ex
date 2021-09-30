defmodule History.Pipelines.Queries.SearchInstances do
  alias History.Pipelines

  def call(query) do
    query
    |> Pipelines.Queries.SearchConfigs.call()
    |> Enum.map(fn p ->
      pid = Pipelines.Instance.whereis(p.id)
      status = to_status(pid)

      %Pipelines.Instance{
        id: p.id,
        pid: pid,
        status: status,
        streams: p.streams,
        steps: p.steps
      }
    end)
  end

  defp to_status(pid) do
    case pid do
      pid when is_pid(pid) -> :running
      _ -> :unstarted
    end
  end
end
