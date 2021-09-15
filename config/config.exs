# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :quizzical,
  ecto_repos: [Quizzical.Repo]

# Configures the endpoint
config :quizzical, QuizzicalWeb.Endpoint,
  http: [compress: true],
  url: [host: "localhost"],
  secret_key_base: "iTy2Ej/rQI8fp3xgEh4Ixy8XRKIuM5AvPrshe3GNMQQ9siB+DJ08Vb2olNjSzKN7",
  render_errors: [view: QuizzicalWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Quizzical.PubSub,
  live_view: [signing_salt: "zNeeHE/o"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
