defmodule LifeCoachApi.Repo.Migrations.CreateSurveyQuestions do
  use Ecto.Migration

  def change do
    create table(:survey_questions) do
      add :statement, :string
      add :type, :string
      add :weight, :integer
      add :sequence, :integer
      add :value, :string
      add(:options, {:array, :map}, default: [])
      add :survey_template_id, references(:survey_templates, on_delete: :nothing)

      timestamps()
    end

    create index(:survey_questions, [:survey_template_id])
  end
end
