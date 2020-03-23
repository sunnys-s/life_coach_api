defmodule LifeCoachApiWeb.UserController do
  use LifeCoachApiWeb, :controller

  alias LifeCoachApi.Accounts
  alias LifeCoachApi.Accounts.User

  alias LifeCoachApi.Guardian

  action_fallback LifeCoachApiWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    # with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
    #   conn
    #   |> put_status(:created)
    #   |> put_resp_header("location", Routes.user_path(conn, :show, user))
    #   |> render("show.json", user: user)
    # end

    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn |> render("jwt.json", jwt: token, user: user)
    end
  end

  # def show(conn, %{"id" => id}) do
    # user = Accounts.get_user!(id)
    # render(conn, "show.json", user: user)
  # end

  def show(conn,_params) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def update_image(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    IO.inspect(user_params)
    s3_url = LifeCoachApi.AssetStore.upload_image(user_params["profile_picture"])
    IO.inspect(s3_url)
    new_user_params = %{profile_picture: s3_url}
    with {:ok, %User{} = user} <- Accounts.update_user(user, new_user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.token_sign_in(email, password) do
      {:ok, token, user} ->
        conn |> render("jwt.json", jwt: token, user: user)
      _ ->
        {:error, :unauthorized}
    end
  end

  def user_conversations(conn, _params) do
    render(conn, "user_conversations.json")
  end

  def users_of_contacts(conn, _params) do
    render(conn, "users_of_contacts.json")
  end
end
