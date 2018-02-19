defmodule Trademarks.Repo.Migrations.CreateAttorneys do
  use Ecto.Migration

  def change do
    create table(:attorneys, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :case_file_id, references(:case_files, type: :uuid, null: false)
      add :name, :text

      timestamps
    end

    create unique_index(:attorneys, [:name])
    create index(:attorneys, [:case_file_id])
  end
end