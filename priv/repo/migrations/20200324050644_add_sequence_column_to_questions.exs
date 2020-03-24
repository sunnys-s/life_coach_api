defmodule LifeCoachApi.Repo.Migrations.AddSequenceColumnToQuestions do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :sequence, :integer
    end
  end
end
