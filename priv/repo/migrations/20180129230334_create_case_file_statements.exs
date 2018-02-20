defmodule Trademarks.Repo.Migrations.CreateCaseFileStatements do
  use Ecto.Migration

  def change do
    create table(:case_file_statements, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :case_file_id, references(:case_files, type: :uuid, null: false)
      add :type_code, :text
      add :description, :text
      timestamps()
    end

    # The conventional way doesn't work because of long descriptions.
    # create unique_index(:case_file_statements,
    #                     [:case_file_id, :type_code, :description],
    #                     name: :case_file_id_type_code_description_index)

    execute """
    create unique index case_file_id_type_code_description_index
    on case_file_statements (case_file_id, type_code, md5(description));
    """
  end
end