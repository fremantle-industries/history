defmodule History.Pipelines.PipelineConfig do
  @type id :: atom
  @type t :: %__MODULE__{
    id: id,
    start_on_boot: boolean,
    markets: String.t,
    streams: list,
    steps: list
  }

  @enforce_keys ~w[id start_on_boot markets streams steps]a
  defstruct ~w[id start_on_boot markets streams steps]a

  defimpl Stored.Item do
    def key(p) do
      p.id
    end
  end
end
