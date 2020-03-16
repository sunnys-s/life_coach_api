defmodule LifeCoachApiWeb.RoomChannel do
  use LifeCoachApiWeb, :channel

  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      # {:ok, socket}
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    # LifeCoachApi.Message.changeset(%LifeCoachApi.Message{}, payload) |> LifeCoachApi.Repo.insert
    broadcast socket, payload["name"], payload
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    # LifeCoachApi.Message.get_messages()
    # |> Enum.each(fn msg -> push(socket, "shout", %{
    #     name: msg.name,
    #     message: msg.message,
    #   }) end)
    {:noreply, socket} # :noreply
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
