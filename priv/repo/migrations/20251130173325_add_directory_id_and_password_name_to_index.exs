defmodule Talar.Repo.Migrations.AddDirectoryIdAndPasswordNameToIndex do
  use Ecto.Migration

  def change do
    create unique_index(:passwords, [:directory_id, :password_name])
  end
end
