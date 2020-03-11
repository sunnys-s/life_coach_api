defmodule LifeCoachApiWeb.PageController do
  use LifeCoachApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", messages: LifeCoachApi.Message.get_messages(20))
  end
end
