defmodule Trademarks.Repo.Migrations.CreateCaseFileEventStatements do
  use Ecto.Migration

  def change do
    create table(:case_file_event_statements, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :case_file_id, references(:case_files, type: :uuid, null: false)
      add :code, :text
      add :type, :text
      add :description, :text
      add :date, :date
    end

    # The conventional way doesn't work because of long descriptions.
    # create unique_index(:case_file_event_statements,
    #                     [:case_file_id, :code, :type, :description, :date],
    #                     name: :case_file_id_code_type_description_date_index)

    execute """
    create unique index case_file_id_code_type_description_date_index
    on case_file_event_statements (case_file_id, code, type, md5(description), date);
    """
  end
end