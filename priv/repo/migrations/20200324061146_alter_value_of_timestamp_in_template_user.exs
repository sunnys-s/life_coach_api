defmodule LifeCoachApi.Repo.Migrations.AlterValueOfTimestampInTemplateUser do
  use Ecto.Migration

  def change do
    alter table(:template_user) do
      modify(:inserted_at, :timestamp, default: fragment("NOW()"))
      modify(:updated_at, :timestamp, default: fragment("NOW()"))
    end
  end
end
