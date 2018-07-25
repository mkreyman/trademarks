defmodule Mix.Tasks.Ingest do
  use Mix.Task

  alias Trademarks.Util.Parser

  alias Trademarks.Models.Nodes.{
    Address,
    Attorney,
    CaseFile,
    Correspondent,
    EventStatement,
    Owner,
    Statement,
    Trademark
  }

  alias Trademarks.Models.Links.{
    Aka,
    CommunicatesWith,
    Describes,
    FiledBy,
    FiledFor,
    Owns,
    PartyTo,
    RepresentedBy,
    ResidesAt,
    Updates
  }

  def run([file]) do
    {:ok, _started} = Application.ensure_all_started(:trademarks)
    ingest(file)
  end

  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:trademarks)
    ingest("./tmp/seed.zip")
  end

  defp ingest(file) do
    Mix.shell().info("Parsing file #{file} ...")
    started = :os.system_time(:seconds)

    {:ok, stream} = Parser.parse(file)

    stream
    # |> Enum.take(10)
    |> Enum.map(&process(&1))

    finished = :os.system_time(:seconds)

    Mix.shell().info(
      "Finished in #{finished - started} secs\n Summary:\n #{inspect(display_count())}\n"
    )
  end

  defp process(%{} = case_file) do
    tm = Trademark.create(%Trademark{name: case_file.trademark_name})
    attorney = Attorney.create(%Attorney{name: case_file.attorney})

    cf =
      CaseFile.create(%CaseFile{
        serial_number: case_file.serial_number,
        abandonment_date: case_file.abandonment_date,
        filing_date: case_file.filing_date,
        registration_date: case_file.registration_date,
        registration_number: case_file.registration_number,
        renewal_date: case_file.renewal_date,
        status_date: case_file.status_date
      })

    correspondent =
      Correspondent.create(%Correspondent{
        address_1: case_file.correspondent.address_1,
        address_2: case_file.correspondent.address_2,
        address_3: case_file.correspondent.address_3,
        address_4: case_file.correspondent.address_4,
        address_5: case_file.correspondent.address_5
      })

    Enum.map(case_file.case_file_owners, fn params ->
      owner =
        Owner.create(%Owner{
          name: params.name,
          dba: params.dba,
          nationality_state: params.nationality_state,
          nationality_country: params.nationality_country
        })

      address =
        Address.create(%Address{
          address_1: params.address_1,
          address_2: params.address_2,
          city: params.city,
          state: params.state,
          postcode: params.postcode,
          country: params.country
        })

      link(owner, ResidesAt, address, cf.status_date)
      link(owner, Owns, tm)
      link(owner, PartyTo, cf)
      link(owner, RepresentedBy, attorney)
    end)

    Enum.map(case_file.case_file_event_statements, fn params ->
      event_statement =
        EventStatement.create(%EventStatement{
          description: params.description
        })

      link(event_statement, Updates, cf, params.date)
    end)

    Enum.map(case_file.case_file_statements, fn params ->
      statement =
        Statement.create(%Statement{
          description: params.description
        })

      link(statement, Describes, cf)
    end)

    link(attorney, Aka, correspondent)
    link(cf, CommunicatesWith, correspondent)
    link(cf, FiledBy, attorney)
    link(cf, FiledFor, tm)
  end

  defp link(from, relationship, to) do
    relationship.link(from, to)
  end

  defp link(from, relationship, to, date) do
    relationship.link(from, to, date)
  end

  defp display_count() do
    """
    MATCH (n) RETURN DISTINCT count(labels(n)), labels(n);
    """
    |> Neo4j.Core.exec_raw()
    |> Enum.map(fn %{"count(labels(n))" => count, "labels(n)" => [label]} -> %{label => count} end)
  end
end

# Mix.Tasks.Ingest.run()
