defmodule Trademarks.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :address_1, :text
      add :address_2, :text
      add :city, :text
      add :state, :text
      add :postcode, :text
      add :country, :text
      timestamps()
    end

    create unique_index(:addresses, [:address_1, :address_2, :postcode],
                        name: :address_1_address_2_postcode_index)

  end
end
