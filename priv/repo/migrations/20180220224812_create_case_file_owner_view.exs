defmodule Trademarks.Repo.Migrations.CreateCaseFileOwnerView do
  use Ecto.Migration

  def up do
    execute """
    CREATE VIEW case_file_owner_view AS
      select o.id as owner_id,
             o.party_name as owner_name,
             o.address_1 as owner_address_1,
             o.address_2 as owner_address_2,
             o.city as owner_city,
             o.state as owner_state,
             o.postcode as owner_postcode,
             f.id as case_file_id,
             f.serial_number,
             f.registration_number,
             f.filing_date,
             f.registration_date,
             f.trademark,
             f.renewal_date
      from case_file_owners o
      left join case_files_case_file_owners fo on (o.id = fo.case_file_owner_id)
      left join case_files f on (fo.case_file_id = f.id)
      group by o.id, f.id;
    """
  end

  def down do
    execute "DROP VIEW case_file_owner_view;"
  end
end
