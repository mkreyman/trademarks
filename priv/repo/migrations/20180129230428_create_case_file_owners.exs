defmodule Trademarks.Repo.Migrations.CreateCaseFileOwners do
  use Ecto.Migration

  def change do
    create table(:case_file_owners, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :party_name, :text
      add :address_1, :text
      add :address_2, :text
      add :city, :text
      add :state, :text
      add :postcode, :text
      timestamps()
    end

    create unique_index(:case_file_owners, :party_name)
  end
end
