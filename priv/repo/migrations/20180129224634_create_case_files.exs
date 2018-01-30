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
      add :attorney_name, :text
      add :renewal_date, :date

      timestamps
    end
  end
end
