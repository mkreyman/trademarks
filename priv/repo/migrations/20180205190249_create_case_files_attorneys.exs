defmodule Trademarks.Repo.Migrations.CreateCaseFilesAttorneys do
  use Ecto.Migration

  def change do
    create table(:case_files_attorneys, primary_key: false) do
      add :case_file_id, references(:case_files, type: :uuid, null: false)
      add :attorney_id, references(:attorneys, type: :uuid, null: false)
    end
  end
end
