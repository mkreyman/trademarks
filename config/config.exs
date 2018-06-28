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
  pubsub: [name: Trademarks.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :bolt_sips, Bolt,
  url:
    "http://" <>
      (("#{System.get_env("NEO4J_HOST")}" != "" && "#{System.get_env("NEO4J_HOST")}") ||
         "localhost") <> ":7687",
  pool_size: 5,
  max_overflow: 2,
  timeout: 30_000
  # url: "bolt://hobby-happyHoHoHo.dbs.graphenedb.com:24786",
  # basic_auth: [username: "demo", password: "demo"]
  # ssl: true,
  # retry_linear_backoff: [delay: 150, factor: 2, tries: 3]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
