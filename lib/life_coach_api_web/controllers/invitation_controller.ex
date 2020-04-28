defmodule LifeCoachApiWeb.InvitationController do 

    alias LifeCoachApi.Invitaion
    alias LifeCoachApi.Accounts
    alias LifeCoachApi.Accounts.User

    use LifeCoachApiWeb, :controller


    def index(conn, _params) do 
        invitaions = Invitaion.list_all()
        render(conn, "index.html", invitaions: invitaions)
    end 

    def new(conn, _params) do 
        IO.inspect(_params)
        render(conn, "new.html", token: get_csrf_token(), invite: _params["invite"])
    end

    def register(conn, _params) do 
        %{"user" => user_params} = _params
        %{"invite" => invite_params} = _params
        {:ok, %User{} = user} = Accounts.create_user(user_params)
        {:ok, %Invitaion{} = invitaion} = Invitaion.create_invite(%{invited_by_id: invite_params["invited_by_user_id"], registered_user_id: 1})
        conn |> redirect(to: "/registration_success")
    end

    def registration_success(conn, _params) do 
        conn |> render("registration_success.html")
    end
end 