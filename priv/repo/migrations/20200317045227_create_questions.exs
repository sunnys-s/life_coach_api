defmodule LifeCoachApi.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :statement, :string
      add :type, :string
      add :weight, :integer
      add :value, :string
      add :template_id, references(:templates, on_delete: :nothing)
      add(:options, {:array, :map}, default: [])
      timestamps()
    end

    create index(:questions, [:template_id])
  end
end
