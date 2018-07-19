# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :trademarks, TrademarksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pL2zrg64jDf5o0OpGHAr25DfnVu3KL0MvSZPI3nJzS1Y6O0zbdvBIo3LTPEt4Xc/",
  render_errors: [view: TrademarksWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Trademarks.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :bolt_sips, Bolt,
  url:
    "http://" <>
      (("#{System.get_env("NEO4J_HOST")}" != "" && "#{System.get_env("NEO4J_HOST")}") ||
         "localhost") <> ":7687",
  pool_size: 10,
  max_overflow: 2,
  timeout: 30_000

# url: "bolt://hobby-happyHoHoHo.dbs.graphenedb.com:24786",
# basic_auth: [username: "demo", password: "demo"]
# ssl: true,
# retry_linear_backoff: [delay: 150, factor: 2, tries: 3]

config :trademarks,
  user_agent: "Elixir elixir@test.com",
  trademarks_url: "https://bulkdata.uspto.gov/data/trademark/dailyxml/applications/",
  temp_dir: "./tmp/",
  temp_page: "./tmp/trademarks.html",
  temp_file: "./tmp/trademarks.zip",
  proxy: System.get_env("HTTPS_PROXY")

# mime-type to serialize JSON API
config :phoenix, :format_encoders, "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
