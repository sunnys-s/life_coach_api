defmodule LifeCoachApi.Repo do
  use Ecto.Repo,
    otp_app: :life_coach_api,
    adapter: Ecto.Adapters.Postgres
end
