# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

config :quizzical, Quizzical.Mailer,
  adapter: Bamboo.SendGridAdapter,
  # API Key name: Quizzical Mail Sending
  # SendGrid API Key ID: ej9BH7EQTI6gSKV4udCheg
  api_key:
    System.get_env("SENDGRID_API_KEY") ||
      raise "enviroment variable for SENDGRID_API_KEY mising",
        hackney_opts: [
          recv_timeout: :timer.minutes(1)
        ]
      )

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :quizzical, Quizzical.Repo,
  ssl: true,
  url: database_url,
  timeout: 60_000,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :quizzical, QuizzicalWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :quizzical, QuizzicalWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
