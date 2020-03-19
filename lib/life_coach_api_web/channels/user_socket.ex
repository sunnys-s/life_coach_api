defmodule LifeCoachApiWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", LifeCoachApiWeb.RoomChannel
  channel "room:lobby", LifeCoachApiWeb.RoomChannel
  channel "user:*", LifeCoachApiWeb.UserChannel
  channel "chat:*", LifeCoachApiWeb.ChatChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(para, socket, _connect_info) do
    IO.inspect(para["token"])
    if LifeCoachApi.Helper.ensure_hash(para["token"], '#{para["user_id"]}:#{para["user_name"]}') do
      {:ok, socket |> assign(:user_id, para["user_id"])}
    else
      {:error, %{reason: "unauthorized"}}
    end
    # {:ok, socket}
  end

  # def connect(p, socket, _connect_info) do
  #   IO.inspect(para)
  #   if LifeCoachApi.Helper.ensure_hash(para["token"], "#{user_id}:#{user_name}") do
  #     {:ok, socket |> assign(:user_id, para["user_id"])}
  #   else
  #     {:error, %{reason: "unauthorized"}}
  #   end
  # end
  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     LifeCoachApiWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
