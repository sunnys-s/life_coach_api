defmodule LifeCoachApiWeb.ResponseControllerTest do
  use LifeCoachApiWeb.ConnCase

  alias LifeCoachApi.Survey
  alias LifeCoachApi.Survey.Response

  @create_attrs %{
    rating: 42,
    type: "some type",
    value: "some value",
    weight: 42
  }
  @update_attrs %{
    rating: 43,
    type: "some updated type",
    value: "some updated value",
    weight: 43
  }
  @invalid_attrs %{rating: nil, type: nil, value: nil, weight: nil}

  def fixture(:response) do
    {:ok, response} = Survey.create_response(@create_attrs)
    response
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all responses", %{conn: conn} do
      conn = get(conn, Routes.response_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create response" do
    test "renders response when data is valid", %{conn: conn} do
      conn = post(conn, Routes.response_path(conn, :create), response: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.response_path(conn, :show, id))

      assert %{
               "id" => id,
               "rating" => 42,
               "type" => "some type",
               "value" => "some value",
               "weight" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.response_path(conn, :create), response: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update response" do
    setup [:create_response]

    test "renders response when data is valid", %{conn: conn, response: %Response{id: id} = response} do
      conn = put(conn, Routes.response_path(conn, :update, response), response: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.response_path(conn, :show, id))

      assert %{
               "id" => id,
               "rating" => 43,
               "type" => "some updated type",
               "value" => "some updated value",
               "weight" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, response: response} do
      conn = put(conn, Routes.response_path(conn, :update, response), response: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete response" do
    setup [:create_response]

    test "deletes chosen response", %{conn: conn, response: response} do
      conn = delete(conn, Routes.response_path(conn, :delete, response))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.response_path(conn, :show, response))
      end
    end
  end

  defp create_response(_) do
    response = fixture(:response)
    {:ok, response: response}
  end
end
