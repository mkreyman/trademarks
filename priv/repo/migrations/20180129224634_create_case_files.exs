defmodule Trademarks.Repo.Migrations.CreateCaseFiles do
  use Ecto.Migration

  def change do
    create table(:case_files, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :serial_number, :text
      add :registration_number, :text
      add :filing_date, :date
      add :registration_date, :date
      add :trademark, :text
      add :renewal_date, :date
      add :attorney_id, references(:attorneys, type: :uuid, null: false)
      add :correspondent_id, references(:correspondents, type: :uuid, null: false)
      timestamps()
    end

    create unique_index(:case_files, [:serial_number])
    create index(:case_files, [:trademark])
    create index(:case_files, [:attorney_id])
    create index(:case_files, [:correspondent_id])
  end
end
