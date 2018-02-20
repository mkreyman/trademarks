# Trademarks

## Description

Download and parse trademark files from https://bulkdata.uspto.gov/data/trademark/dailyxml/applications/.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `trademarks` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:trademarks, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/trademarks](https://hexdocs.pm/trademarks).

## How to use

```elixir
alias Trademarks.{
    Downloader,
    Parser,
    CaseFile,
    CaseFileOwner,
    Attorney,
    CaseFileStatement,
    CaseFileEventStatement,
    Correspondent,
    Repo}
Downloader.start
{:ok, stream} = Parser.start("./tmp/trademarks.zip")
CaseFile.process(stream)
Repo.all(CaseFile) |> Enum.count
Repo.all(CaseFileOwner) |> Enum.count
Repo.all(Attorney) |> Enum.count
attorney = Repo.all(Attorney) |> Repo.preload(:case_files) |> Enum.at(0)
attorney.case_files
Repo.all(CaseFileStatement) |> Enum.count
Repo.all(CaseFileEventStatement) |> Enum.count
Repo.all(Correspondent) |> Enum.count
params = %{party_name: "united"}
CaseFileOwner.find(params)
params2 = %{trademark: "diamond"}
params3 = %{trademark: "prime", exact: true}
CaseFile.find(params2)
params4 = %{attorney_name: "Jim H. Salter"}
Attorney.find(params4)
```

