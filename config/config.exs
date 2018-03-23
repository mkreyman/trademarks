# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :trademarks, ecto_repos: [Trademarks.Repo]

# Configures the endpoint
config :trademarks, TrademarksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZnzBycP+9Q6/KDfzpSMo0IseEOvZUt0vokaLKNb+y5v+frwbyu7MvIUFAqml1+Tu",
  render_errors: [view: TrademarksWeb.ErrorView, accepts: ~w(json json-api)],
  pubsub: [name: Trademarks.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

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
