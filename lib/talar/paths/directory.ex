defmodule Talar.Paths.Directory do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:path, :string, autogenerate: false}
  @derive {Phoenix.Param, key: :path}
  @foreign_key_type :string
  schema "directories" do
    # has_many :directories, Talar.Paths.Directory, foreign_key: :directory_path
    # belongs_to :directory, Talar.Paths.Directory
    field :directory_path, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:path])
    |> validate_required([:path])
  end
end
