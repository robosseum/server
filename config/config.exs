# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :robosseum,
  ecto_repos: [Robosseum.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :robosseum, RobosseumWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BhNK0nW1A+pyO1eBHs+nVwvMtzrJ1VyvtBWvhvZKdt5lD31hhPYIrPzn4ybgtwBz",
  render_errors: [view: RobosseumWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Robosseum.PubSub,
  live_view: [signing_salt: "2FtbzKy+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  slimeex: PhoenixSlime.LiveViewEngine

# Default Robosseum table config
config :robosseum, table_config: %{chips: 10000, blind: 5, blind_increase: 10}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
