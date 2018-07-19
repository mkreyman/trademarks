defmodule Trademarks.Util.Filter do
  # import Util.PipeDebug

  def process(record) do
    %{
      attorney: attorney(record.attorney),
      case_file: case_file(record),
      correspondent: correspondent(record.correspondent),
      event_statements: event_statements(record.case_file_event_statements, []),
      owners: owners(record.case_file_owners, []),
      statements: statements(record.case_file_statements, []),
      trademark: trademark(record.trademark_name)
    }
  end

  defp case_file(record) do
    %{
      serial_number: record.serial_number,
      abandonment_date: String.to_integer(record.abandonment_date),
      filing_date: record.filing_date,
      registration_date: String.to_integer(record.registration_date),
      registration_number: record.registration_number,
      renewal_date: String.to_integer(record.renewal_date),
      status_date: String.to_integer(record.status_date)
    }
  end

  defp attorney(attorney_name) do
    %{name: String.upcase(attorney_name)}
  end

  defp correspondent(correspondent) do
    %{
      address_1: String.upcase(correspondent.address_1),
      address_2: correspondent.address_2,
      address_3: correspondent.address_3,
      address_4: correspondent.address_4,
      address_5: correspondent.address_5
    }
  end

  defp trademark(trademark_name) do
    %{name: String.upcase(trademark_name)}
  end

  defp owners([], list), do: list

  defp owners([owner | case_file_owners], list) do
    list = [
      %{
        name: owner.name,
        dba: owner.dba,
        nationality_state: owner.nationality_state,
        nationality_country: owner.nationality_country,
        address: %{
          address_1: owner.address_1,
          address_2: owner.address_2,
          city: owner.city,
          postcode: owner.postcode,
          state: owner.state,
          country: owner.country
        }
      }
      | list
    ]

    owners(case_file_owners, list)
  end

  defp event_statements([], list), do: list

  defp event_statements([event_statement | case_file_event_statements], list) do
    list = [
      %{
        date: String.to_integer(event_statement.date),
        description: event_statement.description
      }
      | list
    ]

    event_statements(case_file_event_statements, list)
  end

  defp statements([], list), do: list

  defp statements([statement | case_file_statements], list) do
    list = [%{description: statement.description} | list]
    statements(case_file_statements, list)
  end
end
