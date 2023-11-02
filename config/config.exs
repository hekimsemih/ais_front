# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ais_front,
  ecto_repos: [AisFront.Repo, AisFront.RepoBack]

# Configures the endpoint
config :ais_front, AisFrontWeb.Endpoint,
  url: [host: nil],
  secret_key_base: "0gs9bBLG9Sww5n3wl/tRVyhjN+RXOC4zuO940bQXQHMZbHdocAOL1G8FHgcewk31",
  render_errors: [view: AisFrontWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: AisFront.PubSub,
  live_view: [signing_salt: "oh/8LJJ4"],
  http: [compress: true]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use Jason for geo_postgis
config :geo_postgis,
  json_library: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
