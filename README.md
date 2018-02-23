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
  Correspondent,
  Repo,
  Search
}
Downloader.start
{:ok, stream} = Parser.start("./tmp/trademarks.zip")
{:ok, stream} = Parser.start("./tmp/sample.zip")
{:ok, stream} = Parser.start("./tmp/apc180211.zip")
{:ok, stream} = Parser.start("./tmp/apc180131.zip")
CaseFile.process(stream)
Repo.all(CaseFile) |> Enum.count
Repo.all(CaseFileOwner) |> Enum.count
Repo.all(Attorney) |> Enum.count
owner = Repo.all(CaseFileOwner) |> Repo.preload(:case_files) |> Enum.at(0)
owner.case_files
Repo.all(Correspondent) |> Enum.count
params = %{owner: "CUTEX", trademark: "CLEANPULP", attorney: "Mark", correspondent: "Salter"}
params2 = %{trademark: "prime", exact: true}
Search.by_trademark(params)
Search.by_owner(params)
Search.by_attorney(params)
Search.by_correspondent(params)
Search.linked_trademarks(params)
Search.linked_owners(params)
```

