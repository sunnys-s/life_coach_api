defmodule LifeCoachApi.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message, :string
    field :name, :string

    timestamps()
  end

  def get_messages(limit \\ 20) do
    # LifeCoachApi.Repo.all(LifeCoachApi.Message, limit: limit)
    [
      %{
          isGroup: false,
          msg: %{
              id: 10,
              sender: 0,
              body: "if you go to the movie, then give me a call",
              time: "April 27, 2018 22:41:55",
              status: 2,
              recvId: 4,
              recvIsGroup: false,
          },
          contact: %{
              id: 4,
              name: "Dee",
              number: "+91 72781 38213",
              pic: "images/dsaad212312aGEA12ew.png",
              lastSeen: "Apr 27 2018 17:28:10",
          },
          name: "Dee",
          unread: 0
      },
      %{
          isGroup: false,
          msg: %{
              id: 10,
              sender: 0,
              body: "if you go to the movie, then give me a call",
              time: "April 27, 2018 22:41:55",
              status: 2,
              recvId: 4,
              recvIsGroup: false,
          },
          contact: %{
              id: 5,
              name: "Dee 1",
              number: "+91 72781 38213",
              pic: "images/dsaad212312aGEA12ew.png",
              lastSeen: "Apr 27 2018 17:28:10",
          },
          name: "Dee1",
          unread: 0
      }
    ]
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :message])
    |> validate_required([:name, :message])
  end
end
