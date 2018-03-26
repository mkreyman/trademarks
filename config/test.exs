use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :trademarks, TrademarksWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :trademarks, Trademarks.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  database: "trademarks_test",
  hostname: System.get_env("DB_HOST"),
  pool: Ecto.Adapters.SQL.Sandbox
