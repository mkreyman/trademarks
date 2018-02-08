defmodule Trademarks.Repo.Migrations.CreateCaseFilesCaseFileOwners do
  use Ecto.Migration

  def change do
    create table(:case_files_case_file_owners, primary_key: false) do
      add :case_file_id, references(:case_files, type: :uuid, null: false)
      add :case_file_owner_id, references(:case_file_owners, type: :uuid, null: false)
    end
  end
end
