defmodule LifeCoachApi.SurveyTest do
  use LifeCoachApi.DataCase

  alias LifeCoachApi.Survey

  describe "templates" do
    alias LifeCoachApi.Survey.Template

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def template_fixture(attrs \\ %{}) do
      {:ok, template} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Survey.create_template()

      template
    end

    test "list_templates/0 returns all templates" do
      template = template_fixture()
      assert Survey.list_templates() == [template]
    end

    test "get_template!/1 returns the template with given id" do
      template = template_fixture()
      assert Survey.get_template!(template.id) == template
    end

    test "create_template/1 with valid data creates a template" do
      assert {:ok, %Template{} = template} = Survey.create_template(@valid_attrs)
      assert template.name == "some name"
    end

    test "create_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Survey.create_template(@invalid_attrs)
    end

    test "update_template/2 with valid data updates the template" do
      template = template_fixture()
      assert {:ok, %Template{} = template} = Survey.update_template(template, @update_attrs)
      assert template.name == "some updated name"
    end

    test "update_template/2 with invalid data returns error changeset" do
      template = template_fixture()
      assert {:error, %Ecto.Changeset{}} = Survey.update_template(template, @invalid_attrs)
      assert template == Survey.get_template!(template.id)
    end

    test "delete_template/1 deletes the template" do
      template = template_fixture()
      assert {:ok, %Template{}} = Survey.delete_template(template)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_template!(template.id) end
    end

    test "change_template/1 returns a template changeset" do
      template = template_fixture()
      assert %Ecto.Changeset{} = Survey.change_template(template)
    end
  end

  describe "questions" do
    alias LifeCoachApi.Survey.Question

    @valid_attrs %{statement: "some statement", type: "some type", value: "some value", weight: 42}
    @update_attrs %{statement: "some updated statement", type: "some updated type", value: "some updated value", weight: 43}
    @invalid_attrs %{statement: nil, type: nil, value: nil, weight: nil}

    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Survey.create_question()

      question
    end

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Survey.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Survey.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = Survey.create_question(@valid_attrs)
      assert question.statement == "some statement"
      assert question.type == "some type"
      assert question.value == "some value"
      assert question.weight == 42
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Survey.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, %Question{} = question} = Survey.update_question(question, @update_attrs)
      assert question.statement == "some updated statement"
      assert question.type == "some updated type"
      assert question.value == "some updated value"
      assert question.weight == 43
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Survey.update_question(question, @invalid_attrs)
      assert question == Survey.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Survey.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Survey.change_question(question)
    end
  end
end
