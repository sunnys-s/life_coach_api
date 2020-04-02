defmodule LifeCoachApiWeb.QuestionView do
  use LifeCoachApiWeb, :view
  alias LifeCoachApiWeb.QuestionView

  def render("index.json", %{questions: questions}) do
    %{data: render_many(questions, QuestionView, "question.json")}
  end

  def render("show.json", %{question: question}) do
    %{data: render_one(question, QuestionView, "question.json")}
  end

  def render("question.json", %{question: question}) do
    %{
      id: question.id,
      statement: question.statement,
      type: question.type,
      weight: question.weight,
      value: question.value,
      template_id: question.template_id,
      sequence: question.sequence,
      options: render_many(question.options, QuestionView, "option.json")
    }
  end

  def render("option.json", %{question: option}) do
    %{
      label: option.label,
      value: option.value,
      test: option.test
    }
  end

end
