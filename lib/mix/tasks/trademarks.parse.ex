defmodule Mix.Tasks.Trademarks.Parse do
  use Mix.Task

  @shortdoc "Unzips and parses trademarks file"

  @moduledoc """

    This task unzips and parses trademarks zip file.

      ## Usage

      mix trademarks.parse
      mix trademarks.parse <valid_relative_or_absolute_zip_file_path>

  """

  def run(args) do
    Mix.Task.run("app.start")

    args
    |> parse_args()
    |> check_if_valid_file()
    |> parse_file()
  end

  defp parse_args(args) do
    with {_, options, _} <- OptionParser.parse(args) do
      if Enum.empty?(options) do
        Mix.shell().info("No input provided, using default...")
        Application.get_env(:trademarks, :temp_file)
      else
        List.first(options)
      end
    end
  end

  defp check_if_valid_file(file) do
    if File.exists?(file) do
      file
    else
      Mix.shell().info("\n\tPlease verify the file exists: \n\t#{Path.expand(file)}\n")
      raise "File not found"
    end
  end

  defp parse_file(file) do
    Mix.shell().info("Parsing file #{file} ...")

    with {:ok, stream} <- Trademarks.Parser.parse(file) do
      Trademarks.Persistor.process(stream)
    else
      _ ->
        Mix.shell().info("Something went wrong")
    end

    Mix.shell().info("Done")
  end
end
