defmodule Trademarks.Parser do
  require Logger
  import SweetXml

  @temp_dir Application.get_env(:trademarks, :temp_dir)

  def start(zip_file) do
    with {:ok, xml_file} <- extract(zip_file),
         %File.Stream{} = doc <- File.stream!(xml_file) do
      stream =
        stream_tags(doc, [:"case-file"])
        |> Stream.map(fn {_, doc} ->
          doc
          |> xmap(
            serial_number: ~x[./serial-number/text()]s,
            registration_number: ~x[./registration-number/text()]s,
            filing_date: ~x[./case-file-header/filing-date/text()]s,
            status_date: ~x[./case-file-header/status-date/text()]s,
            registration_date: ~x[./case-file-header/registration-date/text()]so,
            abandonment_date: ~x[./case-file-header/abandonment-date/text()]so,
            trademark_name: ~x[./case-file-header/mark-identification/text()]so,
            renewal_date: ~x[./case-file-header/renewal-date/text()]so,
            attorney: ~x[./case-file-header/attorney-name/text()]so,
            case_file_statements: [
              ~x[./case-file-statements/case-file-statement]l,
              type_code: ~x[./type-code/text()]s,
              description: ~x[./text/text()]s
            ],
            case_file_event_statements: [
              ~x[./case-file-event-statements/case-file-event-statement]l,
              code: ~x[./code/text()]s,
              event_type: ~x[./type/text()]s,
              description: ~x[./description-text/text()]s,
              date: ~x[./date/text()]s
            ],
            correspondent: [
              ~x[./correspondent],
              address_1: ~x[./address-1/text()]s,
              address_2: ~x[./address-2/text()]s,
              address_3: ~x[./address-3/text()]s,
              address_4: ~x[./address-4/text()]s,
              address_5: ~x[./address-5/text()]s
            ],
            case_file_owners: [
              ~x[./case-file-owners/case-file-owner]l,
              name: ~x[./party-name/text()]s,
              dba: ~x[./dba-aka-text/text()]s,
              nationality_country: ~x[./nationality/country/text()]s,
              nationality_state: ~x[./nationality/state/text()]s,
              address_1: ~x[./address-1/text()]so,
              address_2: ~x[./address-2/text()]so,
              city: ~x[./city/text()]s,
              state: ~x[./state/text()]so,
              postcode: ~x[./postcode/text()]so,
              country: ~x[./country/text()]s
            ]
          )
        end)

      {:ok, stream}
    else
      _ -> {:error, zip_file}
    end
  end

  def extract(zip_file) do
    unzip_options = [{:cwd, @temp_dir}]
    Logger.info("Extracting #{zip_file} ...")

    result =
      zip_file
      |> String.to_charlist()
      |> :zip.unzip(unzip_options)

    case result do
      {:ok, [xml_file]} ->
        Logger.info(fn ->
          "Extracted #{zip_file} into #{xml_file}"
        end)

        {:ok, xml_file}

      _ ->
        {:error, zip_file}
    end
  end
end
