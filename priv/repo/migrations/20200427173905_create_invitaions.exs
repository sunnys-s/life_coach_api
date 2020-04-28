defmodule LifeCoachApi.Repo.Migrations.CreateInvitaions do
  use Ecto.Migration

  def change do
    create table(:invitaions) do
      add :invited_by_id, :integer
      add :registered_user_id, :integer

      timestamps()
    end

  end
end
