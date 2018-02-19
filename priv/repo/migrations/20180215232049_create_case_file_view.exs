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
             f.attorney
      from case_files f;
    """
  end

  def down do
    execute "DROP VIEW case_file_view;"
  end
end
