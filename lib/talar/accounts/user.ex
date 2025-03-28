defmodule Talar.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    # has_many :groups, Talar.Accounts.Group
    has_many :groups, Talar.GroupsPasswordsUsers
    has_many :passwords, Talar.GroupsPasswordsUsers

    timestamps(type: :utc_datetime)

    field :password, :string, virtual: true, redact: true
    field :password_confirmation, :string, virtual: true, redact: true
    # field :save, :boolean, virtual: false, redact: true
  end

  @valid_email_regex ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  @required_fields [:name, :email, :password, :password_confirmation]

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 1, max: 50)
    |> validate_length(:email, max: 255)
    |> validate_format(:email, @valid_email_regex)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        if password do
          put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
        else
          changeset
        end

      _ ->
        changeset
    end
  end
end
