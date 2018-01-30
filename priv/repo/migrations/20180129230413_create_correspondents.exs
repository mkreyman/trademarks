defmodule Trademarks.Repo.Migrations.CreateCorrespondents do
  use Ecto.Migration

  def change do
    create table(:correspondents, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :case_file_id, references(:case_files, type: :uuid, null: false)
      add :address_1, :text
      add :address_2, :text
      add :address_3, :text
      add :address_4, :text

      timestamps
    end

    create index(:correspondents, [:case_file_id])
  end
end
