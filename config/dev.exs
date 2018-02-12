use Mix.Config

# Configure your database
config :trademarks, Trademarks.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "svcdgccodev",
  password: "",
  database: "trademarks_dev",
  hostname: "localhost",
  pool_size: 10,
  ownership_timeout: 450_000,
  timeout: 450_000,
  pool_timeout: 450_000

# tell logger to load a LoggerFileBackend processes
config :logger,
  backends: [{LoggerFileBackend, :error_log}]

# configuration for the {LoggerFileBackend, :error_log} backend
config :logger, :error_log,
  path: "log/app.log",
  level: :info,
  truncate: :infinity