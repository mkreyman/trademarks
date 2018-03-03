# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :trademarks, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:trademarks, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

# config :trademarks,
#   user_agent: "Elixir elixir@test.com",
#   trademarks_url: "https://bulkdata.uspto.gov/data/trademark/dailyxml/applications/",
#   temp_dir: System.get_env("TMPDIR"),
#   temp_page: System.get_env("TMPDIR") <> "trademarks.html",
#   temp_file: System.get_env("TMPDIR") <> "trademarks.zip"

# General application configuration
config :trademarks, ecto_repos: [Trademarks.Repo]

config :trademarks,
  user_agent: "Elixir elixir@test.com",
  trademarks_url: "https://bulkdata.uspto.gov/data/trademark/dailyxml/applications/",
  temp_dir: "./tmp/",
  temp_page: "./tmp/trademarks.html",
  temp_file: "./tmp/trademarks.zip"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
