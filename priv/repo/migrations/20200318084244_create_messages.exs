defmodule LifeCoachApi.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:msgs) do
      add :room, :string
      add :text, :string
      add :user_id, :integer
      add :opponent_id, :integer
      add :sent_at, :naive_datetime
      add :is_delivered, :boolean, default: false, null: false

      timestamps()
    end
    create index(:msgs, [:room])
    create index(:msgs, [:opponent_id, :is_delivered])
    create index(:msgs, [:opponent_id, :is_delivered, :id])
  end
end
