defmodule LifeCoachApi.Repo.Migrations.AddColumnSurveyTemplateToResponses do
  use Ecto.Migration

  def change do
    alter table(:responses) do
      add :survey_template_id, references(:survey_templates, on_delete: :nothing)
      add :survey_question_id, references(:survey_questions, on_delete: :nothing)
      remove :question_id, references(:questions, on_delete: :nothing)
    end
  end
end
