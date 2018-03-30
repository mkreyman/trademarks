defmodule Mix.Tasks.Trademarks.Download do
  use Mix.Task

  @shortdoc "Downloads most recent daily trademarks file"

  @moduledoc """
    Downloads the most recent daily file from 
    https://bulkdata.uspto.gov/data/trademark/dailyxml/applications/.
  """

  def run(_args) do
    Mix.Task.run("app.start")
    Mix.shell().info("Downloading...")

    Trademarks.Downloader.download()

    Mix.shell().info("Done")
  end
end
