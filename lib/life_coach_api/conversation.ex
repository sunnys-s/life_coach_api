defmodule LifeCoachApi.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "msgs" do
    field :is_delivered, :boolean, default: false
    # field :opponent_id, :integer
    field :room, :string
    field :sent_at, :naive_datetime
    field :text, :string
    # field :user_id, :integer

    timestamps()

    belongs_to :user, LifeCoachApi.Accounts.User
    belongs_to :opponent, LifeCoachApi.Accounts.User
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:room, :text, :user_id, :opponent_id, :sent_at, :is_delivered])
    |> validate_required([:room, :text, :user_id, :opponent_id, :sent_at, :is_delivered])
  end
end
