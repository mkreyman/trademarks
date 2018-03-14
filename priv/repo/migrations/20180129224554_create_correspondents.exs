defmodule Trademarks.Repo.Migrations.CreateCorrespondents do
  use Ecto.Migration

  def change do
    create table(:correspondents, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :address_1, :text
      add :address_2, :text
      add :address_3, :text
      add :address_4, :text
      add :address_5, :text
      
      timestamps()
    end

    create unique_index(:correspondents, :address_1)
  end
end