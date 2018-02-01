defmodule Trademarks.Repo.Migrations.CreateActionKeys do
  use Ecto.Migration

  def change do
    create table(:action_keys, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :action_key_code, :text

      timestamps
    end
  end
end