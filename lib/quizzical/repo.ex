defmodule Quizzical.Repo do
  use Ecto.Repo,
    otp_app: :quizzical,
    adapter: Ecto.Adapters.Postgres
end
