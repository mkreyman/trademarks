# Trademarks

## Description

Download and parse trademark files from https://bulkdata.uspto.gov/data/trademark/dailyxml/applications/.

## How to install

### ...locally

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

If you are behind a proxy, make sure to also set `HTTPS_PROXY` variable, i.e.:
```
export HTTPS_PROXY="http://username:password@corporate.proxy.com:port_number/"
```

Check `config/config.exs` for other configuration options, i.e. `temp_dir`, `temp_page` and `temp_file`.


...then

```
git clone <this repo>
cd trademarks
mix deps.get
mix ecto.setup

# seed the db (optional)
mix run priv/repo/seeds.exs

# download the latest daily trademarks file;
# it would be saved as <temp_dir>/<temp_file>
mix trademarks.download

# parse the default file
mix trademarks.parse

# otherwise, specify file path for a zip file to be parsed
mix trademarks.parse <path/filename.zip>
```

### ...in Docker container

```
docker-compose up web

# seed the db (optional)
docker-compose exec web mix run priv/repo/seeds.exs
```


## How to use

### ...from iex

```elixir
# Download the last daily zip file with trademark case files
# from https://bulkdata.uspto.gov/data/trademark/dailyxml/applications/
Downloader.download

# You could also download any zip file from that page manually and
# then provide its local path as input to Parser.parse().
{:ok, stream} = Parser.parse("./tmp/trademarks.zip")

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

### ...from an API client, i.e. Postman

```
# after the database has been populated/seeded
mix phx.server
```

Then point your API client to...

```
# List all records
http://localhost:4000/api/v1/v1/attorneys/
http://localhost:4000/api/v1/trademarks/
http://localhost:4000/api/v1/case_file_owners/
http://localhost:4000/api/v1/correspondents/

# List a particular record
http://localhost:4000/api/v1/attorneys/attorney_uuid
http://localhost:4000/api/v1/trademarks/trademark_uuid
http://localhost:4000/api/v1/case_file_owners/case_file_owner_uuid
http://localhost:4000/api/v1/correspondents/correspondent_uuid
http://localhost:4000/api/v1/case_files/case_file_uuid

# Search
http://localhost:4000/api/v1/attorneys?name=attorney_name
http://localhost:4000/api/v1/trademarks?name=trademark_name
http://localhost:4000/api/v1/case_file_owners?name=owner_name
http://localhost:4000/api/v1/correspondents?name=correspondent_name
```

NOTE: Your requests must be configured with `content-type` set to `application/vnd.api+json` in the header. Navigating to the above links from a web browser won't work. Read about `JSON API` specification at http://jsonapi.org/format/.


All results are paginated and contain navigation links. Get results from a specific page by appending links with `&page=number`. You could limit the number of results returned by appending `&limit=number` to any link (though you would still get at least one page of results).

