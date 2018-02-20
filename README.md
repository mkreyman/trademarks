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
  CaseFileOwnerView,
  Attorney,
  Correspondent,
  Repo,
  Search
}
Downloader.start
{:ok, stream} = Parser.start("./tmp/trademarks.zip")
{:ok, stream} = Parser.start("./tmp/sample.zip")
CaseFile.process(stream)
Repo.all(CaseFile) |> Enum.count
Repo.all(CaseFileOwner) |> Enum.count
Repo.all(Attorney) |> Enum.count
attorney = Repo.all(Attorney) |> Repo.preload(:case_files) |> Enum.at(0)
attorney.case_files
Repo.all(Correspondent) |> Enum.count
params = %{party_name: "united"}
Search.by_owner(params)
params2 = %{trademark: "diamond"}
params3 = %{trademark: "prime", exact: true}
Search.by_trademark(params2)
params4 = %{attorney: "Jim H. Salter"}
Search.by_attorney(params4)
params5 = %{correspondent: "Salter"}
Search.by_correspondent(params4)
```

