defmodule Trademarks.Parser do
  require Logger
  import SweetXml

  def start(zip_file) do
    with {:ok, xml_file} <- extract(zip_file),
         {:ok, xml}      <- File.read(xml_file) do
      Logger.info "Parsing #{xml_file} ..."
      parse(xml)
      |> xmap(
        created_on: ~x[//trademark-applications-daily/creation-datetime/text()]s,
        applications: [
          ~x[//trademark-applications-daily/application-information/file-segments/action-keys]l,
          action_key: ~x[./action-key/text()]s,
          case_files: [
            ~x[./case-file]l,
            serial_number: ~x[./serial-number/text()]s,
            registration_number: ~x[./registration-number/text()]s,
            filing_date: ~x[./case-file-header/filing-date/text()]s,
            registration_date: ~x[./case-file-header/registration-date/text()]s,
            mark_identification: ~x[./case-file-header/mark-identification/text()]s,
            attorney_name: ~x[./case-file-header/attorney-name/text()]s,
            renewal_date: ~x[./case-file-header/renewal-date/text()]s,
            case_file_statements: [
              ~x[./case-file-statements/case-file-statement]l,
              type_code: ~x[./type-code/text()]s,
              text: ~x[./text/text()]s
            ],
            case_file_event_statements: [
              ~x[./case-file-event-statements/case-file-event-statement]l,
              code: ~x[./code/text()]s,
              type: ~x[./type/text()]s,
              description: ~x[./description-text/text()]s,
              date: ~x[./date/text()]s
            ],
            correspondent: ~x[./correspondent/address-1/text()]s
          ]
        ]
        )
    else
      _ -> {:error, :parsing_error}
    end
  end

  def extract(zip_file) do
    unzip_options = [ {:cwd, System.get_env("TMPDIR")} ]
    Logger.info "Extracting #{zip_file} ..."
    result        = zip_file
                    |> String.to_charlist()
                    |> :zip.unzip(unzip_options)

    case result do
      {:ok, [xml_file]} ->
        Logger.info "Extracted #{zip_file} into #{xml_file}"
        {:ok, xml_file}
      _ ->
        {:error, zip_file}
    end
  end
end