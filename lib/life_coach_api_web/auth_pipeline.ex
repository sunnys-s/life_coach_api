defmodule LifeCoachApi.Guardian.AuthPipeline do
    use Guardian.Plug.Pipeline, otp_app: :life_coach_api,
    module: LifeCoachApi.Guardian,
    error_handler: LifeCoachApi.AuthErrorHandler
  
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
end