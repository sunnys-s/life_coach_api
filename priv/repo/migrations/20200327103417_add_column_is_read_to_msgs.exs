defmodule LifeCoachApi.Repo.Migrations.AddColumnIsReadToMsgs do
  use Ecto.Migration

  def change do
    alter table(:msgs) do
      add :is_read, :boolean, default: false, null: false
    end
  end
end
