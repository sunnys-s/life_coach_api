defmodule LifeCoachApi.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :value, :string
      add :type, :string
      add :weight, :integer
      add :rating, :integer
      add :template_id, references(:templates, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :question_id, references(:questions, on_delete: :nothing)

      timestamps()
    end

    create index(:responses, [:template_id])
    create index(:responses, [:user_id])
    create index(:responses, [:question_id])
  end
end
