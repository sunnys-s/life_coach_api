# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :life_coach_api,
  ecto_repos: [LifeCoachApi.Repo]

# Configures the endpoint
config :life_coach_api, LifeCoachApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uM2uINcJnrf61XZh+8GkTh7apRvbVGI+tKEDnew3WT0XXBTWq1m/e2Lw8czgcNZ6",
  render_errors: [view: LifeCoachApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LifeCoachApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use guardian for API authentication
config :life_coach_api, LifeCoachApi.Guardian,
  issuer: "lifeCoachApi",
  secret_key: "Ji/+HzNoJhwJabK4QFPIyiYhAXKDx5vFGr54LeU/+CW+J0HmBsqA/G15nq8hjMQW"

config :arc,
  bucket: System.get_env("AWS_BUCKET")

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY"),
  secret_access_key: System.get_env("AWS_SECRET_KEY"),
  region: System.get_env("S3_REGION")

config :recaptcha,
    public_key: System.get_env("RECAPTCHA_PUBLIC_KEY"),
    secret: System.get_env("RECAPTCHA_PRIVATE_KEY"),
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
