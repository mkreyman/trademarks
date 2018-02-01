defmodule Trademarks.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      supervisor(Trademarks.Repo, [])
      # Starts a worker by calling: Trademarks.Worker.start_link(arg)
      # {Trademarks.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Trademarks.Supervisor]
    Supervisor.start_link(children, opts)
  end
end