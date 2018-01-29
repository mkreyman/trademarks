use Mix.Config

# Configure your database
config :trademarks, Trademarks.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "svcdgccodev",
  password: "",
  database: "trademarks_dev",
  hostname: "localhost",
  pool_size: 10