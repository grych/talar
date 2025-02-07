defmodule Talar.Paths.Directory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "directories" do
    field :path, :string
    field :directory_id, :integer
    has_many :directories, Talar.Paths.Directory
    #belongs_to :directory, Talar.Paths.Directory

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:path])
    |> validate_required([:path])
  end
end
