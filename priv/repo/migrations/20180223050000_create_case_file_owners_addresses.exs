defmodule Trademarks.Repo.Migrations.CreateCaseFileOwnersAddresses do
  use Ecto.Migration

  def change do
    create table(:case_file_owners_addresses, primary_key: false) do
      add :case_file_owner_id, references(:case_file_owners, type: :uuid, null: false)
      add :address_id, references(:case_files, type: :uuid, null: false)
    end

    create unique_index(:case_file_owners_addresses,
                        [:case_file_owner_id, :address_id],
                        name: :case_file_owner_id_address_id_index)
  end
end
