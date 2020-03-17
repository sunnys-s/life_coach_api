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
end
