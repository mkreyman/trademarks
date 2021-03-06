defmodule Trademarks.Repo.Migrations.CreateCaseFileEventStatements do
  use Ecto.Migration

  def change do
    create table(:case_file_event_statements, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :code, :text
      add :date, :date
      add :description, :text
      add :event_type, :text
      add :case_file_id, references(:case_files, type: :uuid, null: false, on_delete: :nothing)
      
      timestamps()
    end

    # The conventional way doesn't work because of long descriptions.
    execute """
    create unique index case_file_id_code_type_description_date_index
    on case_file_event_statements (case_file_id, code, event_type, md5(description), date);
    """
  end
end