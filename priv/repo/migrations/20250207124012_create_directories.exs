defmodule Talar.Repo.Migrations.CreateDirectories do
  use Ecto.Migration

  def change do
    create table(:directories) do
      add :path, :string, size: 4096
      add :directory_id, references(:directories, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:directories, [:directory_id])
  end
end
