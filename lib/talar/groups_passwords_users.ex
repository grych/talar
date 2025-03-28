defmodule Talar.GroupsPasswordsUsers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups_passwords_users" do
    belongs_to :group, Talar.Paths.Group
    belongs_to :password, Talar.Paths.Password
    belongs_to :user, Talar.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(groups_passwords_users, attrs) do
    groups_passwords_users
    |> cast(attrs, [])
    |> validate_required([])
  end
end
