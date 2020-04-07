defmodule LifeCoachApiWeb.SurveyTemplateView do
  use LifeCoachApiWeb, :view
  alias LifeCoachApiWeb.SurveyTemplateView

  def render("index.json", %{survey_templates: survey_templates}) do
    %{data: render_many(survey_templates, SurveyTemplateView, "survey_template.json")}
  end

  def render("show.json", %{survey_template: survey_template}) do
    %{data: render_one(survey_template, SurveyTemplateView, "survey_template.json")}
  end

  def render("survey_template.json", %{survey_template: template}) do
    %{
      id: template.id,
      name: template.name,
      user_id: template.user_id,
      inserted_at: template.inserted_at,
      updated_at: template.updated_at
    }
  end

  def render("template_show.json", %{survey_template: template}) do
    %{
      id: template.id,
      name: template.name,
      user_id: template.user_id,
      questions: render_many(template.survey_questions, SurveyTemplateView, "quest.json")
    }
  end

  def render("quest.json", %{survey_template: question}) do
    %{
      id: question.id,
      statement: question.statement,
      type: question.type,
      weight: question.weight,
      value: question.value,
      sequence: question.sequence,
      options: render_many(question.options, SurveyTemplateView, "option.json")
    }
  end

  def render("option.json", %{survey_template: option}) do
    %{
      label: option.label,
      value: option.value,
      test: option.test
    }
  end
end
