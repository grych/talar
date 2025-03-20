defmodule Talar.Repo.Migrations.CreateDirectories do
  use Ecto.Migration

  def change do
    create table(:directories) do
      add :directory_name, :string, size: 4096
      add :directory_id, references(:directories, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:directories, [:directory_id])
    create index(:directories, :directory_name)
    create unique_index(:directories, [:directory_name, :directory_id])
  end
end
