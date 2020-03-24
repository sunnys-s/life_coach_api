defmodule LifeCoachApi.Survey.Template do
  use Ecto.Schema
  import Ecto.Changeset

  alias LifeCoachApi.Accounts.User

  schema "templates" do
    field :name, :string
    field :user_id, :id

    timestamps()

    many_to_many(
      :users,
      User,
      join_through: "template_user",
      on_replace: :delete
    )
    has_many :questions, LifeCoachApi.Survey.Question
  end

  @doc false
  def changeset(template, attrs) do
    template
    |> cast(attrs, [:name, :user_id])
    |> cast_assoc(:questions)
    |> validate_required([:name])
  end
end
