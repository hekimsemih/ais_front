defmodule AisFront.RepoBack do
  use Ecto.Repo,
    otp_app: :ais_front,
    adapter: Ecto.Adapters.Postgres
end

