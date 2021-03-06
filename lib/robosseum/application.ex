defmodule Robosseum.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Robosseum.Repo,
      # Start the Telemetry supervisor
      RobosseumWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Robosseum.PubSub},
      # Start the Endpoint (http/https)
      RobosseumWeb.Endpoint,
      {Registry, keys: :unique, name: Registry.Tables},
      Robosseum.Server.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Robosseum.Supervisor]
    Supervisor.start_link(children, opts)
    # supervisor = Supervisor.start_link(children, opts)

    # Task.start(fn -> Robosseum.Tables.restore_all() end)

    # supervisor
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RobosseumWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
