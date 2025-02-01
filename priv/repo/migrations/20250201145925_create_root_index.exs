defmodule Talar.Repo.Migrations.CreateRootIndex do
  use Ecto.Migration

  def change do
    create index(:directories, [:root])
  end
end
