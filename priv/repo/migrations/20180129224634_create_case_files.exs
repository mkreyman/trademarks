defmodule Trademarks.Repo.Migrations.CreateCaseFiles do
  use Ecto.Migration

  def change do
    create table(:case_files, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :serial_number, :text
      add :registration_number, :text
      add :filing_date, :date
      add :registration_date, :date
      add :mark_identification, :text
      add :renewal_date, :date
      add :attorney, :text
      add :case_file_statements, :text
      add :case_file_event_statements, :text
      add :correspondent, :text
      timestamps()
    end

    create unique_index(:case_files, [:serial_number])
  end
end
