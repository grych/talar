defmodule Talar.Paths.Directory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "directories" do
    field :directory_name, :string
    field :directory_id, :integer
    has_many :directories, Talar.Paths.Directory
    # belongs_to :directory, Talar.Paths.Directory

    timestamps(type: :utc_datetime)
  end

  @valid_name_regex ~r/\A[a-z0-9-_]+\z/

  @doc false
  def changeset(directory, attrs) do
    # IO.inspect(directory)
    directory
    |> cast(attrs, [:id, :directory_id, :directory_name])
    |> validate_required([:directory_name, :directory_id])
    |> validate_format(:directory_name, @valid_name_regex)
    |> validate_length(:directory_name, min: 1, max: 4096)
    |> unique_constraint([:directory_name, :directory_id])
  end
end
