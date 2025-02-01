defmodule Talar.Repo.Migrations.AddRootToDirectories do
  use Ecto.Migration

  def change do
    alter table(:directories) do
      add :root, :boolean, default: false, null: false
    end
  end
end
