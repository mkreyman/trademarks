defmodule Trademarks.Parser do
  require Logger
  import SweetXml

  @temp_dir Application.get_env(:trademarks, :temp_dir)

  def start(zip_file) do
    with {:ok, xml_file}           <- extract(zip_file),
         %File.Stream{} = doc      <- File.stream!(xml_file) do
      started = :os.system_time(:seconds)
      Logger.info "Parsing #{xml_file} ..."
      stream =
        stream_tags(doc, [:"case-files"]) |>
        Stream.map(fn {_, doc} -> doc |>
          xmap(case_files: [~x[./case-file]l,
               serial_number: ~x[./serial-number/text()]s,
               registration_number: ~x[./registration-number/text()]s,
               filing_date: ~x[./case-file-header/filing-date/text()]s,
               registration_date: ~x[./case-file-header/registration-date/text()]so,
               mark_identification: ~x[./case-file-header/mark-identification/text()]s,
               attorney_name: ~x[./case-file-header/attorney-name/text()]s,
               renewal_date: ~x[./case-file-header/renewal-date/text()]so,
               case_file_statements: [
                 ~x[./case-file-statements/case-file-statement]l,
                 type_code: ~x[./type-code/text()]s,
                 description: ~x[./text/text()]s
               ],
               case_file_event_statements: [
                 ~x[./case-file-event-statements/case-file-event-statement]l,
                 code: ~x[./code/text()]s,
                 type: ~x[./type/text()]s,
                 description: ~x[./description-text/text()]s,
                 date: ~x[./date/text()]s
               ],
               correspondent: [
                 ~x[./correspondent],
                 address_1: ~x[./address-1/text()]s,
                 address_2: ~x[./address-2/text()]s,
                 address_3: ~x[./address-3/text()]s,
                 address_4: ~x[./address-4/text()]s
               ],
               case_file_owners: [
                 ~x[./case-file-owners/case-file-owner]l,
                 party_name: ~x[./party-name/text()]s,
                 address_1: ~x[./address-1/text()]so,
                 address_2: ~x[./address-2/text()]so,
                 city: ~x[./city/text()]s,
                 state: ~x[./state/text()]s,
                 postcode: ~x[./postcode/text()]so
          ]]) end)
      # json = Poison.encode!(stream)
      # File.write("#{@temp_dir}parsed.json", json, [:binary])

      finished = :os.system_time(:seconds)
      Logger.info "Parsing done in #{finished - started} secs"
      {:ok, stream}
    # else
    #   _ -> {:error, zip_file}
    end
  end

  def extract(zip_file) do
    unzip_options = [ {:cwd, @temp_dir} ]
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