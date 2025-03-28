defmodule Talar.Repo.Migrations.CreateGroup do
  use Ecto.Migration

def change do
    create table(:groups) do
      add :group_name, :string, size: 4096, null: false
      # add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:groups, [:group_name])
    # create index(:groups, [:user_id])
  end
end
