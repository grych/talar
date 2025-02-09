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

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:path, :directory_id, :name])
    |> validate_required([:path, :directory_id])
    # |> put_name()
  end

  # defp put_name(changeset) do
  #   # IO.inspect(changeset.assigns)
  #   name = get_field(changeset, :name)
  #   IO.inspect(name)
  #   put_change(changeset, :path, "////" <> name)
  #   # case changeset do
  #   #   %Ecto.Changeset{valid?: true, changes: %{path: path}} ->
  #   #     put_change(changeset, :name, "////" <> path)
  #   #   _ ->
  #   #     changeset
  #   # end
  # end
end
