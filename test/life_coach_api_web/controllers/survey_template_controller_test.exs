defmodule LifeCoachApiWeb.SurveyTemplateControllerTest do
  use LifeCoachApiWeb.ConnCase

  alias LifeCoachApi.Survey
  alias LifeCoachApi.Survey.SurveyTemplate

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:survey_template) do
    {:ok, survey_template} = Survey.create_survey_template(@create_attrs)
    survey_template
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all survey_templates", %{conn: conn} do
      conn = get(conn, Routes.survey_template_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create survey_template" do
    test "renders survey_template when data is valid", %{conn: conn} do
      conn = post(conn, Routes.survey_template_path(conn, :create), survey_template: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.survey_template_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.survey_template_path(conn, :create), survey_template: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update survey_template" do
    setup [:create_survey_template]

    test "renders survey_template when data is valid", %{conn: conn, survey_template: %SurveyTemplate{id: id} = survey_template} do
      conn = put(conn, Routes.survey_template_path(conn, :update, survey_template), survey_template: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.survey_template_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, survey_template: survey_template} do
      conn = put(conn, Routes.survey_template_path(conn, :update, survey_template), survey_template: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete survey_template" do
    setup [:create_survey_template]

    test "deletes chosen survey_template", %{conn: conn, survey_template: survey_template} do
      conn = delete(conn, Routes.survey_template_path(conn, :delete, survey_template))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.survey_template_path(conn, :show, survey_template))
      end
    end
  end

  defp create_survey_template(_) do
    survey_template = fixture(:survey_template)
    {:ok, survey_template: survey_template}
  end
end
