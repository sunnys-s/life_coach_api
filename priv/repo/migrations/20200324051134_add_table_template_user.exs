defmodule LifeCoachApi.Repo.Migrations.AddTableTemplateUser do
  use Ecto.Migration

  def change do
    create table(:template_user, primary_key: false) do
      add(:template_id, references(:templates, on_delete: :delete_all), primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true)
      timestamps()
    end

    create(index(:template_user, [:template_id]))
    create(index(:template_user, [:user_id]))

    create(
      unique_index(:template_user, [:template_id, :user_id], name: :template_id_user_id_unique_index)
    )
  end
end
