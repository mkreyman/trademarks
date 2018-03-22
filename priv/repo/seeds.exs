# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Trademarks.Repo.insert!(%Trademarks.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Trademarks.{Parser, Persistor}

{:ok, stream} = Parser.start("./priv/repo/seed.zip")
Persistor.process(stream)
File.rm("./priv/repo/seed.xml")