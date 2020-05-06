defmodule LifeCoachApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias LifeCoachApi.Accounts.User
  alias LifeCoachApi.Survey.Template

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string

    # Virtual fields:
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :profile_picture, :string
    field :user_type, :string
    field :otp, :string
    field :mobile_number, :string
    timestamps()

    has_many :conversations, LifeCoachApi.Conversation
    has_many :received_conversations, LifeCoachApi.Conversation, foreign_key: :opponent_id
    has_many :survey_templates, LifeCoachApi.Survey.SurveyTemplate

    many_to_many(
      :templates,
      Template,
      join_through: "template_user",
      on_replace: :delete
    )
    
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation, :profile_picture, :user_type, :otp, :mobile_number])
    # |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> validate_required([:mobile_number])
    |> unique_constraint(:email)
    |> unique_constraint(:mobile_number)
    |> put_password_hash
  end

  def changeset_update_templates(%User{} = user, templates) do
    user
    |> cast(%{}, [:name, :email, :password, :password_confirmation, :profile_picture, :user_type])
    |> put_assoc(:templates, templates)
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}}
        ->
          put_change(changeset, :password_hash, hashpwsalt(pass))
      _ ->
          changeset
    end
  end

  defp put_profile_picture(changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{profile_picture: avatar}}
        ->
          fp = base64_to_upload(avatar)
          IO.inspect fp
          put_change(changeset, :profile_picture, fp)
      _ ->
          IO.inspect changeset
          
          changeset
    end
  end

  def base64_to_upload(str) do
    with {:ok, data} <- Base.decode64(str) do
      binary_to_upload(data)
    end
  end

  def binary_to_upload(binary) do
    with {:ok, path} <- Plug.Upload.random_file("upload"),
         {:ok, file} <- File.open(path, [:write, :binary]),
         :ok <- IO.binwrite(file, binary),
         :ok <- File.close(file) do
      %Plug.Upload{path: path}
    end
  end
end
