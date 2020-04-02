defmodule LifeCoachApiWeb.TemplateView do
  use LifeCoachApiWeb, :view
  alias LifeCoachApiWeb.TemplateView

  def render("index.json", %{templates: templates}) do
    %{data: render_many(templates, TemplateView, "template.json")}
  end

  def render("show.json", %{template: template}) do
    %{data: render_one(template, TemplateView, "template.json")}
  end

  def render("template.json", %{template: template}) do
    %{
      id: template.id,
      name: template.name,
      user_id: template.user_id,
      inserted_at: template.inserted_at,
      updated_at: template.updated_at
    }
  end

  def render("template_show.json", %{template: template}) do
    %{
      id: template.id,
      name: template.name,
      user_id: template.user_id,
      questions: render_many(template.questions, TemplateView, "quest.json")
    }
  end

  def render("quest.json", %{template: question}) do
    %{
      statement: question.statement,
      type: question.type,
      weight: question.weight,
      value: question.value,
      sequence: question.sequence,
      options: render_many(question.options, TemplateView, "option.json")
    }
  end

  def render("option.json", %{template: option}) do
    %{
      label: option.label,
      value: option.value,
      test: option.test
    }
  end
end
