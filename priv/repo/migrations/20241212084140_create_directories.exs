defmodule Talar.Repo.Migrations.CreateDirectories do
  use Ecto.Migration

  def change do
    create table(:directories) do
      add :dir, :string
      #add :directory_id, references(:directories, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
