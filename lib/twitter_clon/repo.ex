defmodule TwitterClon.Repo do
  use Ecto.Repo,
    otp_app: :twitter_clon,
    adapter: Ecto.Adapters.Postgres
end
