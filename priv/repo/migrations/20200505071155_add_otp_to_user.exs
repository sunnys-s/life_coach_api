defmodule LifeCoachApi.Repo.Migrations.AddOtpToUer do
  use Ecto.Migration

  def change do
    alter table(:users) do 
      add :otp, :string 
      add :mobile_number, :string
    end

  end
end
