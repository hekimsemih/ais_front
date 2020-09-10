# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

postgres_user =
  System.get_env("POSTGRES_USER") ||
    raise """
    environment variable POSTGRES_USER is missing.
    """
postgres_pass =
  System.get_env("POSTGRES_PASS") ||
    raise """
    environment variable POSTGRES_PASS is missing.
    """
back_database_host =
  System.get_env("BACK_DATABASE_HOST") ||
    raise """
    environment variable BACK_DATABASE_HOST is missing.
    """
front_database_host =
  System.get_env("FRONT_DATABASE_HOST") ||
    raise """
    environment variable FRONT_DATABASE_HOST is missing.
    """

config :ais_front, AisFront.Repo,
  # ssl: true,
  username: postgres_user,
  password: postgres_pass,
  hostname: front_database_url,
  database: "ais_front_dev",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :ais_front, AisFront.RepoBack,
  # ssl: true,
  username: postgres_user,
  password: postgres_pass,
  hostname: back_database_url,
  database: "ais",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  types: AisFront.PostgresTypes

secret_key_base =
  System.get_env("ELIXIR_SECRET") ||
    raise """
    environment variable ELIXIR_SECRET is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :ais_front, AisFrontWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "80"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :ais_front, AisFrontWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
