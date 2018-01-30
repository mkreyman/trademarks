defmodule Trademarks.Repo.Migrations.CreateCaseFileStatements do
  use Ecto.Migration

  def change do
    create table(:case_file_statements, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :case_file_id, references(:case_files, type: :uuid, null: false)
      add :type_code, :text
      add :description, :text

      timestamps
    end

    create index(:case_file_statements, [:case_file_id])
  end
end
