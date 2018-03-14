defmodule Trademarks.Repo.Migrations.CreateCaseFileOwnersTrademarks do
  use Ecto.Migration

  def change do
    create table(:case_file_owners_trademarks, primary_key: false) do
      add :case_file_owner_id, references(:case_file_owners, type: :uuid, null: false, on_delete: :nothing)
      add :trademark_id, references(:trademarks, type: :uuid, null: false, on_delete: :nothing)

      timestamps()
    end

    create index(:case_file_owners_trademarks, [:case_file_owner_id])
    create index(:case_file_owners_trademarks, [:trademark_id])
    create unique_index(:case_file_owners_trademarks,
                        [:case_file_owner_id, :trademark_id],
                        name: :case_file_owner_id_trademark_id_index)
  end
end