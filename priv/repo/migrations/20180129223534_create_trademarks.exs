defmodule Trademarks.Repo.Migrations.CreateTrademarks do
  use Ecto.Migration

  def change do
    create table(:trademarks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :text
      
      timestamps()
    end

    create unique_index(:trademarks, :name)
  end
end