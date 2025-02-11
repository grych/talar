defmodule Talar.Repo.Migrations.CreateUniqueDirectoryPathIndex do
  use Ecto.Migration

  def change do
    create unique_index(:directories, :path)
  end
end
