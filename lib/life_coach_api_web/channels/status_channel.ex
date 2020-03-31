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
      user = Repo.get!(User, socket.assigns.user_id)
      user_list = Repo.all(from u in User, where: u.user_type != ^user.user_type) |> Enum.map(fn u -> 
        query = from m in Conversation, where: m.opponent_id== ^socket.assigns.user_id and m.user_id == ^u.id and m.is_read == false
        query_d = from m in Conversation, where: m.opponent_id== ^socket.assigns.user_id and m.user_id == ^u.id and m.is_read == false, order_by: [desc: m.sent_at]
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
      users = Enum.sort_by(user_list, &(&1.sent_at)) |> Enum.reverse
      push socket, "init:status_msg", %{users: users}
      Presence.track(socket, socket.assigns.user_id, %{})
      {:noreply, socket}
    end
    
end