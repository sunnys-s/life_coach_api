defmodule LifeCoachApiWeb.ChatChannel do
    use Phoenix.Channel
    alias LifeCoachApi.{Repo,Conversation}
    import Ecto.Query, only: [from: 2]

    alias LifeCoachApiWeb.Presence
  
    def join("chat:" <> users_string, _info, socket) do
      if users_string |> String.split(":") |> Enum.member?(socket.assigns.user_id) do
        send(self(), :after_join)
        {:ok, %{}, socket}
      else
        {:error, %{reason: "unauthorized"}}
      end
    end
  
    def handle_info(:after_join, socket) do
      room = String.replace_prefix(socket.topic, "chat:", "")
      IO.inspect room
      messages = Repo.all(from m in Conversation, where: m.room == ^room, order_by: [desc: m.sent_at], preload: [:user, :opponent]) 
      |> Enum.map(fn m -> %{_id: m.id, sent_at: m.sent_at, text: m.text, user: %{_id: m.opponent_id}} end)

      IO.inspect messages
      push socket, "init:msg", %{messages: messages}
      Presence.track(socket, socket.assigns.user_id, %{})
      {:noreply, socket}
    end
    
    def handle_in("new:msg", msg, socket) do
        opponent_id = socket.topic
          |> String.replace_prefix("chat:", "")
          |> String.split(":")
          |> List.delete(socket.assigns.user_id)
          |> List.first
        
        IO.inspect opponent_id
        changes = %{room: String.replace_prefix(socket.topic, "chat:", ""),
                    user_id: socket.assigns.user_id,
                    opponent_id: msg["body"]["user"]["_id"],
                    text: msg["body"]["text"],
                    sent_at: DateTime.utc_now,
                    is_delivered: false
                   }
        case Conversation.changeset(%Conversation{}, changes) |> Repo.insert do
          {:ok, message} ->
            broadcast! socket, "new:msg", %{_id: message.id, sent_at: message.sent_at, text: message.text, user: %{_id: message.opponent_id}}
            # --------------------
            if Enum.count(Presence.list(socket)) == 1 do
                LifeCoachApiWeb.Endpoint.broadcast!("user:#{opponent_id}", "new:msg", %{user_id: socket.assigns.user_id})
            end
            # --------------------
          {:error, _changeset} -> nil
        end
        {:reply, :ok, socket}
    end

    def handle_in("read:msg", id, socket) do
        room = String.replace_prefix(socket.topic, "chat:", "")
        from(m in Conversation, where: m.room == ^room and m.opponent_id == ^socket.assigns.user_id and m.id <= ^id)
        |> Repo.update_all(set: [is_delivered: true])
        {:noreply, socket}
    end
    
end