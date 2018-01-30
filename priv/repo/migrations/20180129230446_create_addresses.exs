defmodule Trademarks.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :case_file_owner_id, references(:case_file_owners, type: :uuid, null: false)
      add :address_1, :text
      add :address_2, :text
      add :city, :text
      add :state, :text
      add :postcode, :text

      timestamps
    end

    create index(:addresses, [:case_file_owner_id])
  end
end
