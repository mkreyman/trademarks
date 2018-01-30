defmodule Trademarks.Repo.Migrations.CreateCaseFileOwners do
  use Ecto.Migration

  def change do
    create table(:case_file_owners, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :case_file_id, references(:case_files, type: :uuid, null: false)
      add :party_name, :text

      timestamps
    end

    create index(:case_file_owners, [:case_file_id])
  end
end
