defmodule Talar.Paths.Directory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "directories" do
    field :dir, :string
    has_many :directories, Talar.Paths.Directory
    belongs_to :directory, Talar.Paths.Directory

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:dir])
    |> validate_required([:dir])
    |> validate_length(:dir, min: 1, max: 4096)
  end
end
