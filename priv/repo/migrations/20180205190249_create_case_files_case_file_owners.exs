defmodule Trademarks.Repo.Migrations.CreateCaseFilesCaseFileOwners do
  use Ecto.Migration

  def change do
    create table(:case_files_case_file_owners, primary_key: false) do
      add :case_file_id, references(:case_files, type: :uuid, null: false, on_delete: :nothing)
      add :case_file_owner_id, references(:case_file_owners, type: :uuid, null: false, on_delete: :nothing)
      
      timestamps()
    end

    create index(:case_files_case_file_owners, [:case_file_id])
    create index(:case_files_case_file_owners, [:case_file_owner_id])
    create unique_index(:case_files_case_file_owners,
                       [:case_file_id, :case_file_owner_id],
                       name: :case_file_id_case_file_owner_id_index)
  end
end
