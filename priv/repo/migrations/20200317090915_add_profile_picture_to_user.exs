defmodule LifeCoachApi.Repo.Migrations.AddProfilePictureToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profile_picture, :string
      add :name, :string
    end
  end
end
