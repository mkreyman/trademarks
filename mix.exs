defmodule Trademarks.Mixfile do
  use Mix.Project

  def project do
    [
      app: :trademarks,
      version: "0.1.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :logger_file_backend, :ecto, :postgrex],
      mod: {Trademarks.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0.0"},
      {:poison, "~> 3.1"},
      {:sweet_xml, "~> 0.6.5"},
      {:floki, "~> 0.19.2"},
      {:postgrex, "~> 0.13.4"},
      {:ecto, "~> 2.2.8"},
      {:logger_file_backend, "~> 0.0.10"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
