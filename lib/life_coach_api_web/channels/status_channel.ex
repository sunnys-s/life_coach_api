defmodule LifeCoachApiWeb.StatusChannel do
    use Phoenix.Channel
    alias LifeCoachApi.{Repo,Conversation}
    alias LifeCoachApi.Accounts.User
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
    #   room = String.replace_prefix(socket.topic, "chat:", "")
    #   IO.inspect room
    #   messages = Repo.all(from m in Conversation, where: m.room == ^room, order_by: [desc: m.sent_at], preload: [:user, :opponent]) 
    #   |> Enum.map(fn m -> %{_id: m.id, sent_at: m.sent_at, text: m.text, user: %{_id: m.opponent_id}} end)

    #   IO.inspect messages

      users = Repo.all |> Enum.map(fn u -> 
        query = from m in Conversation, where: m.user_id == ^socket.assigns.user_id and m.opponent_id == ^u.id and m.is_read == false
        count = Repo.aggregate(query, :count)
        %{
          id: u.id,
          name: u.name,
          email: u.email,
          profile_picture: u.profile_picture,
          user_type: u.user_type,
          count: count
        }
      end)
      push socket, "init:status_msg", %{users: users}
      Presence.track(socket, socket.assigns.user_id, %{})
      {:noreply, socket}
    end
    
end