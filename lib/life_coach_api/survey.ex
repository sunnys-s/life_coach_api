defmodule LifeCoachApi.Survey do
  @moduledoc """
  The Survey context.
  """

  import Ecto.Query, warn: false
  alias LifeCoachApi.Repo

  alias LifeCoachApi.Survey.Template

  @doc """
  Returns the list of templates.

  ## Examples

      iex> list_templates()
      [%Template{}, ...]

  """
  def list_templates do
    Repo.all(Template)
  end

  @doc """
  Gets a single template.

  Raises `Ecto.NoResultsError` if the Template does not exist.

  ## Examples

      iex> get_template!(123)
      %Template{}

      iex> get_template!(456)
      ** (Ecto.NoResultsError)

  """
  def get_template!(id), do: Repo.get!(Template, id)

  def get_template_with_questions(id) do 
    template = Repo.get!(Template, id) |> Repo.preload([:questions])
    IO.inspect(template)
    template
  end

  @doc """
  Creates a template.

  ## Examples

      iex> create_template(%{field: value})
      {:ok, %Template{}}

      iex> create_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_template(attrs \\ %{}) do
    %Template{}
    |> Template.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a template.

  ## Examples

      iex> update_template(template, %{field: new_value})
      {:ok, %Template{}}

      iex> update_template(template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_template(%Template{} = template, attrs) do
    template
    |> Repo.preload([:questions])
    |> Template.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a template.

  ## Examples

      iex> delete_template(template)
      {:ok, %Template{}}

      iex> delete_template(template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_template(%Template{} = template) do
    Repo.delete(template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking template changes.

  ## Examples

      iex> change_template(template)
      %Ecto.Changeset{source: %Template{}}

  """
  def change_template(%Template{} = template) do
    Template.changeset(template, %{})
  end

  alias LifeCoachApi.Survey.Question

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions do
    Repo.all(Question)
  end

  @doc """
  Returns the list of questions in a template.

  ## Examples

      iex> list_questions_by_template()
      [%Question{}, ...]

  """
  def list_questions_by_template(template_id) do
    query = from q in Question, where: q.template_id == ^template_id, order_by: q.sequence
    Repo.all(query)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id)

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{source: %Question{}}

  """
  def change_question(%Question{} = question) do
    Question.changeset(question, %{})
  end

  alias LifeCoachApi.Survey.Response

  @doc """
  Returns the list of responses.

  ## Examples

      iex> list_responses()
      [%Response{}, ...]

  """
  def list_responses do
    Repo.all(Response)
  end

  @doc """
  Gets a single response.

  Raises `Ecto.NoResultsError` if the Response does not exist.

  ## Examples

      iex> get_response!(123)
      %Response{}

      iex> get_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_response!(id), do: Repo.get!(Response, id)

  @doc """
  Creates a response.

  ## Examples

      iex> create_response(%{field: value})
      {:ok, %Response{}}

      iex> create_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_response(attrs \\ %{}) do
    %Response{}
    |> Response.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a response.

  ## Examples

      iex> update_response(response, %{field: new_value})
      {:ok, %Response{}}

      iex> update_response(response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_response(%Response{} = response, attrs) do
    response
    |> Response.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a response.

  ## Examples

      iex> delete_response(response)
      {:ok, %Response{}}

      iex> delete_response(response)
      {:error, %Ecto.Changeset{}}

  """
  def delete_response(%Response{} = response) do
    Repo.delete(response)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking response changes.

  ## Examples

      iex> change_response(response)
      %Ecto.Changeset{source: %Response{}}

  """
  def change_response(%Response{} = response) do
    Response.changeset(response, %{})
  end

  def list_feedbacks_by_template(template_id, user_id) do
    res = Repo.all from r in Response, where: r.template_id == ^template_id and r.user_id == ^user_id, preload: [:question]
    res |> Enum.map(fn(r) ->  Map.put(r.question, :value, r.value) end) |> Enum.sort_by(&(&1.sequence))
  end

  def bulk_upsert(template_id, user, feedbacks) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    new_feedback_params = feedbacks |> Enum.map(fn(fb) -> 
      %{
        question_id: fb["id"], 
        value: fb["value"], 
        template_id: (template_id |> String.to_integer), 
        user_id: user.id, 
        weight: fb["weight"], 
        type: fb["type"], 
        rating: 0, 
        inserted_at: timestamp, 
        updated_at: timestamp
      } 
    end)
    Repo.insert_all(Response, new_feedback_params, on_conflict: :nothing)
    res = Repo.all from r in Response, where: r.template_id == ^String.to_integer(template_id), preload: [:question]
    res |> Enum.map(fn(r) ->  Map.put(r.question, :value, r.value) end)
  end

  def user_templates(user) do
    u = user |> Repo.preload([:templates])
    u.templates
  end

  def coach_templates(user) do
    templates =
      Template
      |> where([template], template.user_id == ^user.id)
      |> Repo.all()
  end

  alias LifeCoachApi.Survey.SurveyTemplate
  alias LifeCoachApi.Survey.SurveyQuestion

  @doc """
  Returns the list of survey_templates.

  ## Examples

      iex> list_survey_templates()
      [%SurveyTemplate{}, ...]

  """
  def list_survey_templates do
    Repo.all(SurveyTemplate)
  end

  def user_creator_templates(user_id, creator_id) do
    res = Repo.all from st in SurveyTemplate, where: st.creator_id == ^creator_id and st.user_id == ^user_id
    res
  end
  @doc """
  Gets a single survey_template.

  Raises `Ecto.NoResultsError` if the Survey template does not exist.

  ## Examples

      iex> get_survey_template!(123)
      %SurveyTemplate{}

      iex> get_survey_template!(456)
      ** (Ecto.NoResultsError)

  """
  def get_survey_template!(id), do: Repo.get!(SurveyTemplate, id)

  def get_survey_template_with_questions(id) do 
    template = Repo.get!(SurveyTemplate, id) |> Repo.preload([:survey_questions])
    IO.inspect(template)
    template
  end

  @doc """
  Creates a survey_template.

  ## Examples

      iex> create_survey_template(%{field: value})
      {:ok, %SurveyTemplate{}}

      iex> create_survey_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_survey_template(attrs \\ %{}) do
    %SurveyTemplate{}
    |> SurveyTemplate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a survey_template.

  ## Examples

      iex> update_survey_template(survey_template, %{field: new_value})
      {:ok, %SurveyTemplate{}}

      iex> update_survey_template(survey_template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_survey_template(%SurveyTemplate{} = survey_template, attrs) do
    survey_template
    |> SurveyTemplate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a survey_template.

  ## Examples

      iex> delete_survey_template(survey_template)
      {:ok, %SurveyTemplate{}}

      iex> delete_survey_template(survey_template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_survey_template(%SurveyTemplate{} = survey_template) do
    Repo.delete(survey_template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survey_template changes.

  ## Examples

      iex> change_survey_template(survey_template)
      %Ecto.Changeset{source: %SurveyTemplate{}}

  """
  def change_survey_template(%SurveyTemplate{} = survey_template) do
    SurveyTemplate.changeset(survey_template, %{})
  end

  def create_survey_template_by_template_and_user(template_id, user_id) do
    template = Repo.get(Template, template_id) |> Repo.preload([:questions])
    survey_template = %{"name": template.name, "user_id": user_id, creator_id: template.user_id}  
    survey_questions = Enum.map(template.questions, fn q -> %{
      statement: q.statement, 
      value: q.value, 
      weight: q.weight, 
      sequence: q.sequence, 
      type: q.type, 
      options: Enum.map(q.options, fn o -> %{
        label: o.label, 
        test: o.test, 
        value: o.value
      } end)
    } end)
    new_survey_template = Map.put(survey_template, :survey_questions, survey_questions) 
    %SurveyTemplate{} 
    |> SurveyTemplate.changeset(new_survey_template) 
    |> Repo.insert()  
  end

  def list_survey_questions_by_template(template_id) do
    query = from q in SurveyQuestion, where: q.survey_template_id == ^template_id, order_by: q.sequence
    Repo.all(query)
  end

  def list_feedbacks_by_survey_template(template_id, user_id) do
    res = Repo.all from r in Response, where: r.survey_template_id == ^template_id and r.user_id == ^user_id, preload: [:survey_question]
    res |> Enum.map(fn(r) ->  Map.put(r.survey_question, :value, r.value) end) |> Enum.sort_by(&(&1.sequence))
  end

  def bulk_upsert_responses(template_id, user, feedbacks) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    survey_template = Repo.get!(SurveyTemplate, String.to_integer(template_id))
    new_feedback_params = feedbacks |> Enum.map(fn(fb) -> 
      %{
        survey_question_id: fb["id"], 
        value: fb["value"], 
        template_id: survey_template.template_id, 
        survey_template_id: survey_template.id,
        user_id: user.id, 
        weight: fb["weight"], 
        type: fb["type"], 
        rating: 0, 
        inserted_at: timestamp, 
        updated_at: timestamp
      } 
    end)
    Repo.insert_all(Response, new_feedback_params, on_conflict: :nothing)
    res = Repo.all from r in Response, where: r.template_id == ^String.to_integer(template_id), preload: [:survey_question]
    res |> Enum.map(fn(r) ->  Map.put(r.survey_question, :value, r.value) end)
  end
end
