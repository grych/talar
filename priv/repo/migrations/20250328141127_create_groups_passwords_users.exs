defmodule Talar.Repo.Migrations.CreateGroupsPasswordsUsers do
  use Ecto.Migration

  def change do
    create table(:groups_passwords_users) do
      add :groups_id, references(:groups)
      add :passwords_id, references(:passwords)
      add :users_id, references(:users)

      timestamps(type: :utc_datetime)
    end

    # create unique_index(:groups_passwords_users, [:groups_id, :passwords_id, :users_id])
  end
end
