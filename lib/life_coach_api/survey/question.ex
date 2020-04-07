defmodule LifeCoachApi.Survey.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :statement, :string
    field :type, :string
    field :value, :string
    field :weight, :integer
    field :sequence, :integer
    # field :template_id, :id

    timestamps()
    belongs_to :template, LifeCoachApi.Survey.Template
    embeds_many(:options, LifeCoachApi.Survey.Option, on_replace: :delete)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:statement, :type, :weight, :value, :template_id, :sequence])
    |> cast_embed(:options)
    |> validate_required([:statement, :type, :weight, :value])
  end
end
