defmodule Talar.Paths.Password do
  use Ecto.Schema
  import Ecto.Changeset

  schema "passwords" do
    field :password_name, :string
    field :directory_id, :integer

    has_many :groups, Talar.GroupsPasswordsUsers
    has_many :users, Talar.GroupsPasswordsUsers
    # has_many :directories, Talar.Paths.Directory

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(password, attrs) do
    password
    |> cast(attrs, [:password_name, :directory_id])
    |> validate_required([:password_name, :directory_id])
  end
end
