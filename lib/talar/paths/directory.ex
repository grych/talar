defmodule Talar.Paths.Directory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "directories" do
    field :directory_name, :string
    field :directory_id, :integer
    has_many :directories, Talar.Paths.Directory
    #belongs_to :directory, Talar.Paths.Directory
    # field :path, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @valid_name_regex ~r/\A[a-z0-9-_]+\z/

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:id, :directory_id, :directory_name])
    # |> validate_required([:path, :directory_id])
    |> validate_length(:directory_name, min: 1, max: 4096)
    |> validate_format(:directory_name, @valid_name_regex)
    |> unique_constraint([:directory_name, :directory_id])
    # |> put_path()
    # |> put_name()
  end

  # defp put_path(changeset) do
  #   name = get_field(changeset, :name)
  #   name = if name == nil do "" else name end
  #   path = get_field(changeset, :path)
  #   path = if path == nil do "" else path end
  #   # it is weird, I will change it in a future
  #   path = if path == "/" do "" else path end
  #   IO.inspect(path)
  #   put_change(changeset, :path, path <> "/" <> name)
  #   # put_change(changeset, :name, name)
  # end

  # defp put_name(changeset) do
  #   # name = get_field(changeset, :name)
  #   # name = if name == nil do "" else name end
  #   path = get_field(changeset, :path)
  #   path = if path == nil do "" else path end
  #   # it is weird, I will change it in a future
  #   path = if path == "/" do "" else path end

  #   path = String.split(path, "/")
  #   path = Enum.reverse(path) |> List.delete("")
  #   name = List.first(path)
  #   IO.inspect(name)

  #   put_change(changeset, :name, name)
  # end
end
