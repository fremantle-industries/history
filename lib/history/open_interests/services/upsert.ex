defmodule History.OpenInterests.Services.Upsert do
  alias History.OpenInterests.OpenInterest

  @type open_interest :: OpenInterest.t()
  @type attributes :: map

  @spec call(attributes) :: {:ok, open_interest} | {:error, Ecto.Changeset.t()}
  def call(attrs) do
    changeset = OpenInterest.changeset(%OpenInterest{}, attrs)

    History.Repo.insert(
      changeset,
      on_conflict: [
        set: [
          value: Ecto.Changeset.get_field(changeset, :value),
          updated_at: DateTime.utc_now()
        ]
      ],
      conflict_target: [:venue, :symbol]
    )
  end
end
