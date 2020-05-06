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
    get "/invitations", InvitationController, :index
    get "/register", InvitationController, :new
    post "/register", InvitationController, :register
    get "/registration_success", InvitationController, :registration_success
  end


  # Other scopes may use custom stacks.
  scope "/api/v1", LifeCoachApiWeb do
    pipe_through :api

    # resources "/users", UserController, only: [:create, :show]

    post "/sign_up", UserController, :create
    post "/sign_in", UserController, :sign_in
    # get "/users", UserController, :index
    put "/users/:id", UserController, :update
    put "/users/:id/images", UserController, :update_image
    put "/users/:id/upsert_templates", UserController, :upsert_templates
    post "/otp_for_change_password", UserController, :otp_for_change_password
    post "/verify_otp", UserController, :verify_otp
    post "/change_password", UserController, :change_password
  end
  
  scope "/api/v1", LifeCoachApiWeb do
    pipe_through [:api, :jwt_authenticated]
    get "/users", UserController, :index
    get "/users_of_contacts", UserController, :users_of_contacts
    get "/user_conversations", UserController, :user_conversations
    get "/my_user", UserController, :show
    resources "/templates", TemplateController, except: [:new, :edit]
    scope "/templates" do
      get "/my_templates/coach", TemplateController, :coach_template_lists
      get "/my_templates/user", TemplateController, :user_template_lists
      get "/my_templates/user/:creator_id/:user_id", TemplateController, :user_creator_template_lists
    end

    resources "/questions", QuestionController, except: [:new, :edit]
    scope "/questions" do
      get "/template_questions/:template_id", QuestionController, :template_questions
      get "/survey_template_questions/:template_id", QuestionController, :survey_template_questions
      post "/template_feedbacks/:template_id", QuestionController, :bulk_upsert
    end

    resources "/responses", ResponseController, except: [:new, :edit]
    scope "/responses" do
      get "/feedbacks/:template_id", ResponseController, :feedbacks
      post "/:template_id/bulk_upsert", ResponseController, :bulk_upsert
    end

    resources "/survey_templates", SurveyTemplateController, except: [:new, :edit]
    scope "/survey_templates" do
      get "/create_and_share_survey/:template_id/:user_id", SurveyTemplateController, :create_and_share_survey
    end
    
  end
end
