defmodule Talar.Repo.Migrations.AddDirectoryIdToPasswords do
  use Ecto.Migration

  def change do
    alter table(:passwords) do
      add :directory_id, :integer, null: false
    end
  end
end
