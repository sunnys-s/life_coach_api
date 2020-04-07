defmodule LifeCoachApi.Survey.SurveyTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survey_templates" do
    field :name, :string
    field :template_id, :id
    # field :user_id, :id

    timestamps()
    has_many :survey_questions, LifeCoachApi.Survey.SurveyQuestion, on_replace: :nilify
    belongs_to :user, LifeCoachApi.Accounts.User
    belongs_to :creator, LifeCoachApi.Accounts.User
  end

  @doc false
  def changeset(survey_template, attrs) do
    survey_template
    |> cast(attrs, [:name, :creator_id, :user_id])
    |> cast_assoc(:survey_questions)
    |> validate_required([:name])
  end
end
