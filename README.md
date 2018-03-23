# Trademarks

## Description

Download and parse trademark files from https://bulkdata.uspto.gov/data/trademark/dailyxml/applications/.

## How to install

- Install Elixir
- Install PostgreSQL
- Configure local variables in `~/.bash_profile`, i.e.
```
export DB_USER=$USER
export DB_PASSWORD=''
export DB_NAME='trademarks_dev'
export DB_HOST='localhost'
export DATABASE_URL="ecto://$DB_USER:$DB_PASSWORD@$DB_HOST/$DB_NAME"
```

...then

```
git clone <this repo>
cd trademarks
mix deps.get
mix ecto.setup
```

## How to use

### ...from iex

```elixir
# Download the last daily zip file with trademark case files
# from https://bulkdata.uspto.gov/data/trademark/dailyxml/applications/
Downloader.start

# You could also download any zip file from that page manually and
# then provide its local path as input to Parser.start().
{:ok, stream} = Parser.start("./tmp/trademarks.zip")

# A typical daily file contains 50,000 - 100,000 case files and
# may take up to 30 minutes to process.
Persistor.process(stream)

# Get counts
Repo.all(CaseFile) |> Enum.count
Repo.all(CaseFileOwner) |> Enum.count
Repo.all(Attorney) |> Enum.count
Repo.all(Trademark) |> Enum.count
owner = Repo.all(CaseFileOwner) |> Repo.preload(:case_files) |> Enum.at(0)
owner.case_files
Repo.all(Correspondent) |> Enum.count

# Run searches
Search.by_attorney("attorney's name")
Search.by_trademark("trademark name")
Search.by_owner("party name")
Search.by_correspondent("correspondent's name")
Search.linked_trademarks("trademark name")
```

### ...from a browser (after the database has been seeded)

```
mix phx.server
```

Then navigate to...

```
# List all records
http://localhost:4000/api/v1/v1/attorneys/
http://localhost:4000/api/v1/trademarks/
http://localhost:4000/api/v1/case_file_owners/
http://localhost:4000/api/v1/correspondents/

# List a particular record
http://localhost:4000/api/v1/attorneys/attorney_id
http://localhost:4000/api/v1/trademarks/trademark_id
http://localhost:4000/api/v1/case_file_owners/case_file_owner_id
http://localhost:4000/api/v1/correspondents/correspondent_id
http://localhost:4000/api/v1/case_files/case_file_id

# Search
http://localhost:4000/api/v1/search?trademark=trademark_name
http://localhost:4000/api/v1/search?correspondent=correspondent_name
http://localhost:4000/api/v1/search?attorney=attorney_name
http://localhost:4000/api/v1/search?owner=party_name
http://localhost:4000/api/v1/search?linked=trademark_name
```

All results are paginated. The HTTP header contains the following information:

  - `link` - to navigate between pages,
  - `page-number` - current page number,
  - `per-page` - number of results per page,
  - `total` - total number of results,
  - `total-pages` - total number of pages.

You could also append `&page=page_number` to each url to go to a specific page.

