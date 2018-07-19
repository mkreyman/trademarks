use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :trademarks, TrademarksWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Enable or disable PipeDebug: true means silencio
config :logger, :shut_up_pipe_debug, false
