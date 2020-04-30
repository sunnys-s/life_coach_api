defmodule LifeCoachApiWeb.StatusChannel do
    use Phoenix.Channel
    alias LifeCoachApi.{Repo,Conversation}
    alias LifeCoachApi.Accounts.User
    alias LifeCoachApi.Accounts
    import Ecto.Query, only: [from: 2]

    alias LifeCoachApiWeb.Presence
  
    def join("status:" <> users_string, _info, socket) do
      if users_string |> String.split(":") |> Enum.member?(socket.assigns.user_id) do
        send(self(), :after_join)
        {:ok, %{}, socket}
      else
        {:error, %{reason: "unauthorized"}}
      end
    end
  
    def handle_info(:after_join, socket) do
      user = Repo.get!(User, socket.assigns.user_id)
      users = Accounts.contact_users(user)
      push socket, "init:status_msg", %{users: users}
      Presence.track(socket, socket.assigns.user_id, %{})
      {:noreply, socket}
    end
    
end