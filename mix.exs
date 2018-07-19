defmodule Trademarks.Mixfile do
  use Mix.Project

  def project do
    [
      app: :trademarks,
      version: "0.0.1",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Trademarks.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :logger_file_backend,
        :bolt_sips
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:uuid, "~> 1.1"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:httpoison, "~> 1.0.0"},
      {:poison, "~> 3.1"},
      {:sweet_xml, "~> 0.6.5"},
      {:floki, "~> 0.19.2"},
      {:logger_file_backend, "~> 0.0.10"},
      {:scrivener_list, "~> 1.0"},
      {:ja_serializer, "~> 0.12.0"},
      {:bolt_sips, "~> 0.4.11"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "neo4j.drop": ["run lib/scripts/drop.exs"],
      "neo4j.init": ["run lib/scripts/init.exs"],
      # "neo4j.seed": ["run priv/repo/seeds.exs"],
      # "neo4j.reset": ["neo4j.drop", "neo4j.seed"]
    ]
  end
end
