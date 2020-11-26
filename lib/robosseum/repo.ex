defmodule Robosseum.Repo do
  use Ecto.Repo,
    otp_app: :robosseum,
    adapter: Ecto.Adapters.Postgres
end
