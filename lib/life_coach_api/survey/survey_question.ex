defmodule LifeCoachApi.Survey.SurveyQuestion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survey_questions" do
    field :sequence, :integer
    field :statement, :string
    field :type, :string
    field :value, :string
    field :weight, :integer

    timestamps()

    belongs_to :survey_template, LifeCoachApi.Survey.SurveyTemplate
    embeds_many(:options, LifeCoachApi.Survey.Option, on_replace: :delete)
  end

  @doc false
  def changeset(survey_question, attrs) do
    survey_question
    |> cast(attrs, [:statement, :type, :weight, :sequence, :value])
    |> cast_embed(:options)
    |> validate_required([:statement, :type, :weight, :sequence, :value, :options])
  end
end
