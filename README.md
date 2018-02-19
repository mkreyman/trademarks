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
alias Trademarks.{Downloader, Parser, CaseFile, CaseFileOwner, Repo}
Downloader.start
{:ok, stream} = Parser.start("./tmp/trademarks.zip")
CaseFile.process(stream)
Repo.all(CaseFile)
Repo.all(CaseFileOwner)
params = %{party_name: "united"}
CaseFileOwner.find(params)
params2 = %{mark_identification: "diamond"}
params3 = %{mark_identification: "prime", exact: true}
CaseFile.find(params2)
```

