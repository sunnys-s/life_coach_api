defmodule LifeCoachApi.Repo.Migrations.CreateSurveyTemplates do
  use Ecto.Migration

  def change do
    create table(:survey_templates) do
      add :name, :string
      add :template_id, references(:templates, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :creator_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:survey_templates, [:template_id])
    create index(:survey_templates, [:user_id])
  end
end
