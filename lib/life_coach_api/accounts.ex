defmodule LifeCoachApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias LifeCoachApi.Repo

  alias LifeCoachApi.Accounts.User
  alias LifeCoachApi.Survey.Template
  alias LifeCoachApi.Accounts
  alias LifeCoachApi.Conversation

  alias LifeCoachApi.Guardian
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(user) do
    # query = from m in Conversation, where: m.user_id== 13 and m.opponent_id == 1 and m.is_read == false
    # Repo.aggregate(query, :count)
    # users = Repo.all(User)
    users = Repo.all(from u in User, where: u.user_type != ^user.user_type)
    user_list = users |> Enum.map(fn u -> 
      query = from m in Conversation, where: m.opponent_id== ^user.id and m.user_id == ^u.id and m.is_read == false
      query_d = from m in Conversation, where: m.opponent_id== ^user.id and m.user_id == ^u.id and m.is_read == false, order_by: [desc: m.sent_at]
      count = Repo.aggregate(query, :count)
      last = Repo.all(query_d) |> List.first
      sent_at = if last == nil, do: nil, else: last.sent_at
      %{
        id: u.id,
        name: u.name,
        email: u.email,
        profile_picture: u.profile_picture,
        user_type: u.user_type,
        count: count,
        sent_at: sent_at
      }
    end)
    Enum.sort_by(user_list, &(&1.sent_at)) |> Enum.reverse
    
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def token_sign_in(email, password) do
    case email_password_auth(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        {:ok, token, user}
      _ ->
        {:error, :unauthorized}
    end
  end

  defp email_password_auth(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- get_by_email(email),
    do: verify_password(password, user)
  end
  
  defp get_by_email(email) when is_binary(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        dummy_checkpw()
        {:error, "Login error."}
      user ->
        {:ok, user}
    end
  end

  defp verify_password(password, %User{} = user) when is_binary(password) do
    if checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end

  alias LifeCoachApi.Accounts.Profile

  @doc """
  Returns the list of profiles.

  ## Examples

      iex> list_profiles()
      [%Profile{}, ...]

  """
  def list_profiles do
    Repo.all(Profile)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile!(id), do: Repo.get!(Profile, id)

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{source: %Profile{}}

  """
  def change_profile(%Profile{} = profile) do
    Profile.changeset(profile, %{})
  end

  def upsert_template_users(user, template_ids) when is_list(template_ids) do
    templates =
      Template
      |> where([template], template.id in ^template_ids)
      |> Repo.all()

    with {:ok, _struct} <-
           user
           |> Repo.preload([:templates])
           |> User.changeset_update_templates(templates)
           |> Repo.update() do
      {:ok, Accounts.get_user!(user.id)}
    else
      error ->
        error
    end
  end

  def insert_template_users(user, template_ids) when is_list(template_ids) do
    templates =
      Template
      |> where([template], template.id in ^template_ids)
      |> Repo.all()
    old_templates = (user |> Repo.preload([:templates])).templates
    merged = templates ++ old_templates
    with {:ok, _struct} <-
        user
        |> Repo.preload([:templates])
        |> User.changeset_update_templates(merged)
        |> Repo.update() do
      {:ok, Accounts.get_user!(user.id)}
    else
      error ->
        error
    end
  end
end
