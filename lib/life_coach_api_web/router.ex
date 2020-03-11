defmodule LifeCoachApiWeb.Router do
  use LifeCoachApiWeb, :router

  alias LifeCoachApi.Guardian

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/", LifeCoachApiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end


  # Other scopes may use custom stacks.
  scope "/api/v1", LifeCoachApiWeb do
    pipe_through :api

    # resources "/users", UserController, only: [:create, :show]

    post "/sign_up", UserController, :create
    post "/sign_in", UserController, :sign_in
    get "/user_conversations", UserController, :user_conversations
    get "/users_of_contacts", UserController, :users_of_contacts
  end

  scope "/api/v1", LifeCoachApiWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/my_user", UserController, :show
  end
end
