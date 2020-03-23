defmodule LifeCoachApiWeb.ResponseView do
  use LifeCoachApiWeb, :view
  alias LifeCoachApiWeb.ResponseView

  def render("index.json", %{responses: responses}) do
    %{data: render_many(responses, ResponseView, "response.json")}
  end

  def render("show.json", %{response: response}) do
    %{data: render_one(response, ResponseView, "response.json")}
  end

  def render("response.json", %{response: response}) do
    %{id: response.id,
      value: response.value,
      type: response.type,
      weight: response.weight,
      rating: response.rating}
  end
end
