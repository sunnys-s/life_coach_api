defmodule LifeCoachApi.Survey.SurveyOption do
    use Ecto.Schema
    import Ecto.Changeset
    embedded_schema do
        field(:label, :string)
        field(:test, :string)
        field(:value, :string)
    end

    def changeset(schema, params) do
        schema
        |> cast(params, [:label, :test, :value])
    end
end
  