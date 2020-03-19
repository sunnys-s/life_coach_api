defmodule LifeCoachApiWeb.UserView do
  use LifeCoachApiWeb, :view
  alias LifeCoachApiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      profile_picture: user.profile_picture
    }
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end

  def render("user_conversations.json", _ ) do
    %{
      "ZmlsaXBlbmF0YW5hZWwxQGxpdmUuY29t": %{
        "anVsaWFuYUBleGFtcGxlLmNvbQ==": %{
          "email": "juliana@example.com",
          "lastMessage": "I'm leaving home now",
          "name": "Juliana Freitas"
        }
      },
      "anVsaWFuYUBleGFtcGxlLmNvbQ==": %{
        "ZmlsaXBlbmF0YW5hZWwxQGxpdmUuY29t": %{
          "email": "filipenatanael1@live.com",
          "lastMessage": "I'm leaving home now",
          "name": "Filipe Natanael"
        }
      }
    }
  end

  def render("users_of_contacts.json", _ ) do
    %{
      "ZmlsaXBlbmF0YW5hZWwxQGxpdmUuY29t": %{
        "-LIYrkTkJ28REbAhD0Xz": %{
          "email": "juliana@example.com",
          "name": "Juliana Freitas",
          "profileImage": "https://bootdey.com/img/Content/avatar/avatar5.png"
        },
      "-LIYrkTkJ28REbAhD0X5": %{
          "email": "tonystark@exemple.com",
          "name": "Tony Stark",
          "profileImage": "https://bootdey.com/img/Content/avatar/avatar5.png"
        }
      },
      "anVsaWFuYUBleGFtcGxlLmNvbQ==": %{
        "-LJHjLeuvZrC-GTIEL_3": %{
          "email": "filipenatanael1@live.com",
          "name": "Filipe Natanael",
          "profileImage": "https://bootdey.com/img/Content/avatar/avatar5.png"
        }
      }
    }
  end
end
