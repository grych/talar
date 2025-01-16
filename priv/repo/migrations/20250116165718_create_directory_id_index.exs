defmodule Talar.Repo.Migrations.CreateDirectoryIdIndex do
  use Ecto.Migration

  def change do
    create index(:directories, [:directory_id])
  end
end
