defmodule Talar.Paths.Directory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "directories" do
    field :path, :string
    field :directory_id, :integer
    has_many :directories, Talar.Paths.Directory
    #belongs_to :directory, Talar.Paths.Directory
    field :name, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @valid_name_regex ~r/\A[a-z0-9-_]+\z/

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:id, :path, :directory_id, :name])
    |> validate_required([:path, :directory_id])
    |> validate_length(:name, min: 1, max: 4096)
    |> validate_format(:name, @valid_name_regex)
    # |> unique_constraint(:name)
    |> put_path()
    |> put_name()
  end

  defp put_path(changeset) do
    name = get_field(changeset, :name)
    name = if name == nil do "" else name end
    path = get_field(changeset, :path)
    path = if path == nil do "" else path end
    # it is weird, I will change it in a future
    path = if path == "/" do "" else path end
    IO.inspect(path)
    put_change(changeset, :path, path <> "/" <> name)
    # put_change(changeset, :name, name)
  end

  defp put_name(changeset) do
    # name = get_field(changeset, :name)
    # name = if name == nil do "" else name end
    path = get_field(changeset, :path)
    path = if path == nil do "" else path end
    # it is weird, I will change it in a future
    path = if path == "/" do "" else path end

    path = String.split(path, "/")
    path = Enum.reverse(path) |> List.delete("")
    name = List.first(path)
    IO.inspect(name)

    put_change(changeset, :name, name)
  end
end
