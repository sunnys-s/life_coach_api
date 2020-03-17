defmodule LifeCoachApi.Survey.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :statement, :string
    field :type, :string
    field :value, :string
    field :weight, :integer
    field :template_id, :id

    timestamps()
    embeds_many(:options, LifeCoachApi.Survey.Option)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:statement, :type, :weight, :value, :template_id])
    |> cast_embed(:options)
    |> validate_required([:statement, :type, :weight, :value])
  end
end
