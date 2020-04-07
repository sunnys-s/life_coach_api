defmodule LifeCoachApiWeb.SurveyTemplateController do
  use LifeCoachApiWeb, :controller

  alias LifeCoachApi.Survey
  alias LifeCoachApi.Survey.SurveyTemplate

  action_fallback LifeCoachApiWeb.FallbackController

  def index(conn, _params) do
    survey_templates = Survey.list_survey_templates()
    render(conn, "index.json", survey_templates: survey_templates)
  end

  def create(conn, %{"survey_template" => survey_template_params}) do
    with {:ok, %SurveyTemplate{} = survey_template} <- Survey.create_survey_template(survey_template_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.survey_template_path(conn, :show, survey_template))
      |> render("show.json", survey_template: survey_template)
    end
  end

  def show(conn, %{"id" => id}) do
    survey_template = Survey.get_survey_template_with_questions(id)
    render(conn, "template_show.json", survey_template: survey_template)
  end

  def update(conn, %{"id" => id, "survey_template" => survey_template_params}) do
    survey_template = Survey.get_survey_template!(id)

    with {:ok, %SurveyTemplate{} = survey_template} <- Survey.update_survey_template(survey_template, survey_template_params) do
      render(conn, "show.json", survey_template: survey_template)
    end
  end

  def delete(conn, %{"id" => id}) do
    survey_template = Survey.get_survey_template!(id)

    with {:ok, %SurveyTemplate{}} <- Survey.delete_survey_template(survey_template) do
      send_resp(conn, :no_content, "")
    end
  end

  def create_and_share_survey(conn, %{"template_id" => template_id, "user_id" => user_id}) do
   with {:ok, %SurveyTemplate{} = survey_template} <- Survey.create_survey_template_by_template_and_user(template_id, user_id) do
    conn
    |> put_status(:created)
    |> put_resp_header("location", Routes.survey_template_path(conn, :show, survey_template))
    |> render("show.json", survey_template: survey_template)
   end
  end
end
