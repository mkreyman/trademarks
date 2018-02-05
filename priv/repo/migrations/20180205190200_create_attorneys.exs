defmodule Trademarks.Repo.Migrations.CreateAttorneys do
  use Ecto.Migration

  def change do
    create table(:attorneys, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :text

      timestamps()
    end

    create unique_index(:attorneys, [:name])
  end
end
