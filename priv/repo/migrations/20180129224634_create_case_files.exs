defmodule Trademarks.Repo.Migrations.CreateCaseFiles do
  use Ecto.Migration

  def change do
    create table(:case_files, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :attorney_id, references(:attorneys, type: :uuid, null: false)
      add :correspondent_id, references(:correspondents, type: :uuid, null: false)
      add :trademark_id, references(:trademarks, type: :uuid, null: false)
      add :abandonment_date, :date
      add :filing_date, :date
      add :registration_date, :date
      add :registration_number, :text
      add :renewal_date, :date
      add :serial_number, :text
      add :status_date, :date
      timestamps()
    end

    create unique_index(:case_files, :serial_number)
    create index(:case_files, [:attorney_id])
    create index(:case_files, [:correspondent_id])
    create index(:case_files, [:trademark_id])
  end
end
