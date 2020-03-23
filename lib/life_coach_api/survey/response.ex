defmodule LifeCoachApi.Survey.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    field :rating, :integer
    field :type, :string
    field :value, :string
    field :weight, :integer
    field :template_id, :id
    field :user_id, :id
    field :question_id, :id

    timestamps()
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:value, :type, :weight, :rating])
    |> validate_required([:value, :type, :weight, :rating])
  end
end
