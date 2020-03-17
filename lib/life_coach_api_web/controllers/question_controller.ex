defmodule LifeCoachApiWeb.QuestionController do
  use LifeCoachApiWeb, :controller

  alias LifeCoachApi.Survey
  alias LifeCoachApi.Survey.Question

  action_fallback LifeCoachApiWeb.FallbackController

  def index(conn, _params) do
    questions = Survey.list_questions()
    render(conn, "index.json", questions: questions)
  end
  
  def template_questions(conn, %{"template_id" => template_id}) do
    questions = Survey.list_questions_by_template(template_id)
    render(conn, "index.json", questions: questions)
  end


  def create(conn, %{"question" => question_params}) do
    with {:ok, %Question{} = question} <- Survey.create_question(question_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.question_path(conn, :show, question))
      |> render("show.json", question: question)
    end
  end

  def show(conn, %{"id" => id}) do
    question = Survey.get_question!(id)
    render(conn, "show.json", question: question)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Survey.get_question!(id)

    with {:ok, %Question{} = question} <- Survey.update_question(question, question_params) do
      render(conn, "show.json", question: question)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Survey.get_question!(id)

    with {:ok, %Question{}} <- Survey.delete_question(question) do
      send_resp(conn, :no_content, "")
    end
  end
end
