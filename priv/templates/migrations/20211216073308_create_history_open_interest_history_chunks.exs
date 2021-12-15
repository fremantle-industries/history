defmodule <%= module_prefix %>.Repo.Migrations.CreateHistoryOpenInterestHistoryChunks do
  use Ecto.Migration

  def up do
    create table(:open_interest_history_chunks<%= if not is_nil(db_prefix), do: ", prefix: \"#{db_prefix}\"" %>) do
      add(:job_id, references(:open_interest_history_jobs), null: false)
      add(:token_symbol, :string, null: false)
      add(:token_name, :string, null: false)
      add(:status, History.ChunkStatusType.type(), null: false)

      timestamps()
    end

    create(
      unique_index(:open_interest_history_chunks, [:job_id, :token_symbol, :token_name])
    )
  end

  def down do
    drop table(:open_interest_history_chunks)
  end
end
