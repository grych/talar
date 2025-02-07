defmodule Talar.Repo.Migrations.CreateDirectories do
  use Ecto.Migration

  def change do
    create table(:directories, primary_key: false) do
      add :path, :string, primary_key: true, size: 4096
      add :directory_path, references(:directories, type: :string, on_delete: :delete_all, column: :path), size: 4096

      timestamps(type: :utc_datetime)
    end
  end
end
