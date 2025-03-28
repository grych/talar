defmodule Talar.Accounts.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :group_name, :string
    # field :user_id, :id
    belongs_to :user, Talar.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(groups, attrs) do
    groups
    |> cast(attrs, [:group_name])
    |> validate_required([:group_name])
  end
end
