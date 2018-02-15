defmodule Trademarks.Repo.Migrations.CreateCaseFileView do
  use Ecto.Migration

  def up do
    execute """
    CREATE VIEW case_file_view AS
      select f.id as case_file_id,
             f.serial_number,
             f.registration_number,
             f.filing_date,
             f.registration_date,
             f.mark_identification as trademark,
             f.renewal_date,
             f.attorney,
             f.case_file_statements as statements,
             f.case_file_event_statements as event_statements,
             f.correspondent,
             o.id as owner_id,
             o.party_name as owner_name,
             o.address_1 as owner_address_1,
             o.address_2 as owner_address_2,
             o.city as owner_city,
             o.state as owner_state,
             o.postcode as owner_postcode
      from case_files f
      left join case_files_case_file_owners fo on (f.id = fo.case_file_id)
      left join case_file_owners o on (fo.case_file_owner_id = o.id);
    """
  end

  def down do
    execute "DROP VIEW case_file_view;"
  end
end
