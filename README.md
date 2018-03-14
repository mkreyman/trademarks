# Trademarks

## Description

Download and parse trademark files from https://bulkdata.uspto.gov/data/trademark/dailyxml/applications/.

## How to use

```elixir
alias Trademarks.{
  Downloader,
  Parser,
  CaseFile,
  Trademark,
  CaseFileOwner,
  Attorney,
  Correspondent,
  Persistor,
  Repo,
  Search
}
Downloader.start
{:ok, stream} = Parser.start("./tmp/trademarks.zip")
{:ok, stream} = Parser.start("./tmp/sample.zip")
{:ok, stream} = Parser.start("./tmp/apc180218.zip")
Persistor.process(stream)
Repo.all(CaseFile) |> Enum.count
Repo.all(CaseFileOwner) |> Enum.count
Repo.all(Attorney) |> Enum.count
Repo.all(Trademark) |> Enum.count
owner = Repo.all(CaseFileOwner) |> Repo.preload(:case_files) |> Enum.at(0)
owner.case_files
Repo.all(Correspondent) |> Enum.count
params = %{owner: "CUTEX", trademark: "CLEANPULP", attorney: "Mark", correspondent: "Salter"}
params2 = %{trademark: "prime", exact: true}
Search.by_attorney(params)
Search.by_trademark(params)
Search.by_owner(params)
Search.by_correspondent(params)
Search.linked_trademarks(params)
```

