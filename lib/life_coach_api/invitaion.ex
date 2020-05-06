defmodule LifeCoachApi.Invitaion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invitaions" do
    # field :invited_by_id, :integer
    # field :registered_user_id, :integer

    timestamps()
    belongs_to :invited_by, LifeCoachApi.Accounts.User
    belongs_to :registered_user, LifeCoachApi.Accounts.User
  end

  alias LifeCoachApi.Invitaion
  alias LifeCoachApi.Repo


  @doc false
  def changeset(invitaion, attrs) do
    invitaion
    |> cast(attrs, [:invited_by_id, :registered_user_id])
    |> validate_required([:invited_by_id, :registered_user_id])
  end

  def create_invite(attrs) do
      %Invitaion{}
        |> Invitaion.changeset(attrs)
        |>Repo.insert()
  end

  def list_all() do 
      Repo.all(Invitaion)
  end


end
