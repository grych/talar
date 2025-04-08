defmodule Talar.Repo.Migrations.CreatePasswords do
  use Ecto.Migration

  def change do
    create table(:passwords) do
      add :password_name, :string, size: 4096

      timestamps(type: :utc_datetime)
    end
  end
end
