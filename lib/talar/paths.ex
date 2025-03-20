defmodule Talar.Paths do
  @moduledoc """
  The Paths context.
  """

  import Ecto.Query, warn: false
  alias Talar.Repo

  alias Talar.Paths.Directory

  @doc """
  Returns the list of directories.

  ## Examples

      iex> list_directories()
      [%Directory{}, ...]

  """
  def list_directories do
    Repo.all(Directory)
  end

  @doc """
  Returns the list of a directory ID.

  ## Examples

      iex> list_directories(directory_id)
      [%Directory{}, ...]

  """
  def list_directories(directory_id) do
    query = from d in Directory,
      where: (d.directory_id==^directory_id),
      select: [:id, :directory_name, :directory_id]
    Repo.all(query)
  end

   @doc """
  Returns the list of directories on the dir

  ## Examples

      iex> list_directory("/drab")
      {:ok, 7}
      iex> list_directory("/non-exisient")
      {:error, "Directory not found"}

  """
  def list_directory(directory_name) do
    directory_name = String.split(directory_name, "/", trim: true)
    #directory_name = [""] ++ directory_name # adding the ROOT of directory (?)
    # |> Enum.reverse()
    # |> Enum.map(fn x -> x == ""; x end)
    # |> Enum.drop("")
    # |> Enum.filter(fn x -> String.trim(x) <> "" end)
    # IO.inspect(directory_name)
    # directory_id = Repo.get_by(Directory, path: directory).id

    # query =
    #   from Directory,
    #     where: [directory_id: ^directory_id],
    #     select: [:id, :directory_id, :path]

    # query
    # |> Repo.all()
    # |> Enum.map(&add_name/1)
    list_directory(get_root_directory(), directory_name)
  end

  defp list_directory(acc, directory_name) do
    case directory_name do
      [] -> acc
      [head | tail] ->
        {:ok, parent_acc} = acc
        # searching for someone where name=head and directory_id=parent_acc
        query =
          from d in Directory,
            where: (d.directory_name == ^head and d.directory_id==^parent_acc),
            select: [:id]
        all = Repo.all(query)
        if length(all) == 1 do
          acc = {:ok, hd(all).id}
          list_directory(acc, tail)
        else
          {:error, "Can't find the directory"}
        end
        # IO.inspect(all)

      # [""] -> get_root_directory()
    end
  end

  @doc """
  Gets a root directory.

  ## Examples

      iex> get_root_directory()
      {:ok, 1}
      iex> get_root_directory() # is not existenet
      {:error, "No ROOT directory"}
  """
  def get_root_directory() do
    query =
      from d in Directory,
        where: (d.directory_name == "" and is_nil(d.directory_id)),
        select: [:id]

    all = query |> Repo.all()
    if length(all) != 1 do
      {:error, "No ROOT directory"}
    else
      {:ok, hd(all).id}
    end
    # Repo.get_by(Directory, directory_name: "", directory_id: nil)
  end

  defp add_name(%Directory{} = directory) do
    # IO.inspect(directory.path)
    path = String.split(directory.path, "/")
    path = Enum.reverse(path)
    %{directory | name: List.first(path)}
  end

  @doc """
  Gets a single directory.

  Raises `Ecto.NoResultsError` if the Directory does not exist.

  ## Examples

      iex> get_directory!(123)
      %Directory{}

      iex> get_directory!(456)
      ** (Ecto.NoResultsError)

  """
  def get_directory!(id), do: Repo.get!(Directory, id)

  @doc """
  Creates a directory.

  ## Examples

      iex> create_directory(%{field: value})
      {:ok, %Directory{}}

      iex> create_directory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_directory(attrs \\ %{}) do
    %Directory{}
    |> Directory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a directory.

  ## Examples

      iex> update_directory(directory, %{field: new_value})
      {:ok, %Directory{}}

      iex> update_directory(directory, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_directory(%Directory{} = directory, attrs) do
    IO.inspect(attrs)
    directory
    |> Directory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a directory.

  ## Examples

      iex> delete_directory(directory)
      {:ok, %Directory{}}

      iex> delete_directory(directory)
      {:error, %Ecto.Changeset{}}

  """
  def delete_directory(%Directory{} = directory) do
    Repo.delete(directory)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking directory changes.

  ## Examples

      iex> change_directory(directory)
      %Ecto.Changeset{data: %Directory{}}

  """
  def change_directory(%Directory{} = directory, attrs \\ %{}) do
    Directory.changeset(directory, attrs)
  end
end
