defmodule Talar.Paths.Password do
  use Ecto.Schema
  import Ecto.Changeset

  schema "passwords" do
    field :password_name, :string

    has_many :groups, Talar.GroupsPasswordsUsers
    has_many :users, Talar.GroupsPasswordsUsers

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(password, attrs) do
    password
    |> cast(attrs, [:password_name])
    |> validate_required([:password_name])
  end
end
