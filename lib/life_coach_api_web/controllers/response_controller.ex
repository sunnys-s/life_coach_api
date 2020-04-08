defmodule LifeCoachApiWeb.ResponseController do
  use LifeCoachApiWeb, :controller

  alias LifeCoachApi.Survey
  alias LifeCoachApi.Survey.Response

  action_fallback LifeCoachApiWeb.FallbackController

  def index(conn, _params) do
    responses = Survey.list_responses()
    render(conn, "index.json", responses: responses)
  end

  def create(conn, %{"response" => response_params}) do
    with {:ok, %Response{} = response} <- Survey.create_response(response_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.response_path(conn, :show, response))
      |> render("show.json", response: response)
    end
  end

  def show(conn, %{"id" => id}) do
    response = Survey.get_response!(id)
    render(conn, "show.json", response: response)
  end

  def update(conn, %{"id" => id, "response" => response_params}) do
    response = Survey.get_response!(id)

    with {:ok, %Response{} = response} <- Survey.update_response(response, response_params) do
      render(conn, "show.json", response: response)
    end
  end

  def delete(conn, %{"id" => id}) do
    response = Survey.get_response!(id)

    with {:ok, %Response{}} <- Survey.delete_response(response) do
      send_resp(conn, :no_content, "")
    end
  end

  def feedbacks(conn, %{"template_id" => template_id}) do
    user = Guardian.Plug.current_resource(conn)
    questions = Survey.list_feedbacks_by_survey_template(template_id, user.id)
    render(conn, LifeCoachApiWeb.QuestionView, "survey_index.json", questions: questions)
  end

  def bulk_upsert(conn, %{"template_id" => template_id, "feedbacks" => feedback_params}) do
    user = Guardian.Plug.current_resource(conn)
    questions = Survey.bulk_upsert_responses(template_id, user, feedback_params)
    render(conn, LifeCoachApiWeb.QuestionView, "survey_index.json", questions: questions)
  end
end
