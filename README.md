# Trademarks

## Description

Download and parse trademark files from https://bulkdata.uspto.gov/data/trademark/dailyxml/applications/.

## How to use

### ...from iex

```elixir
# To download the last daily zip with case files
Downloader.start

{:ok, stream} = Parser.start("./tmp/trademarks.zip")
Persistor.process(stream)

Repo.all(CaseFile) |> Enum.count
Repo.all(CaseFileOwner) |> Enum.count
Repo.all(Attorney) |> Enum.count
Repo.all(Trademark) |> Enum.count
owner = Repo.all(CaseFileOwner) |> Repo.preload(:case_files) |> Enum.at(0)
owner.case_files
Repo.all(Correspondent) |> Enum.count

Search.by_attorney("attorney's name")
Search.by_trademark("trademark name")
Search.by_owner("party name")
Search.by_correspondent("correspondent's name")
Search.linked_trademarks("trademark name")
```

### ...from a browser

```
mix phx.server
```

Then navigate to...

```
# List all records
http://localhost:4000/api/attorneys/
http://localhost:4000/api/trademarks/
http://localhost:4000/api/case_file_owners/
http://localhost:4000/api/correspondents/
http://localhost:4000/api/case_files/

# List a particular record
http://localhost:4000/api/attorneys/attorney_id
http://localhost:4000/api/trademarks/trademark_id
http://localhost:4000/api/case_file_owners/case_file_owner_id
http://localhost:4000/api/correspondents/correspondent_id
http://localhost:4000/api/case_files/case_file_id

# Search
http://localhost:4000/api/search?trademark=trademark_name
http://localhost:4000/api/search?correspondent=correspondent_name
http://localhost:4000/api/search?attorney=attorney_name
http://localhost:4000/api/search?owner=party_name
http://localhost:4000/api/search?linked=trademark_name
```

All results are paginated. The HTTP header contains the following information:

  - `link` - to navigate between pages,
  - `page-number` - current page number,
  - `per-page` - number of results per page,
  - `total` - total number of results,
  - `total-pages` - total number of pages.

You could also append `&page=page_number` to each url to go to a specific page.

