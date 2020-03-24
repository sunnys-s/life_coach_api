defmodule LifeCoachApiWeb.TemplateController do
  use LifeCoachApiWeb, :controller

  alias LifeCoachApi.Survey
  alias LifeCoachApi.Survey.Template

  action_fallback LifeCoachApiWeb.FallbackController

  def index(conn, _params) do
    templates = Survey.list_templates()
    render(conn, "index.json", templates: templates)
  end

  def create(conn, %{"template" => template_params}) do
    user = Guardian.Plug.current_resource(conn)
    new_template_params = template_params |> Map.put("user_id", user.id)
    with {:ok, %Template{} = template} <- Survey.create_template(new_template_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.template_path(conn, :show, template))
      |> render("show.json", template: template)
    end
  end

  def show(conn, %{"id" => id}) do
    template = Survey.get_template!(id)
    render(conn, "show.json", template: template)
  end

  def update(conn, %{"id" => id, "template" => template_params}) do
    template = Survey.get_template!(id)

    with {:ok, %Template{} = template} <- Survey.update_template(template, template_params) do
      render(conn, "show.json", template: template)
    end
  end

  def delete(conn, %{"id" => id}) do
    template = Survey.get_template!(id)

    with {:ok, %Template{}} <- Survey.delete_template(template) do
      send_resp(conn, :no_content, "")
    end
  end

  def user_template_lists(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    templates = Survey.user_templates(user)
    render(conn, "index.json", templates: templates)
  end

  def coach_template_lists(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    templates = Survey.coach_templates(user)
    render(conn, "index.json", templates: templates)
  end
end
