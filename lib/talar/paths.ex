defmodule Talar.Paths do
  @moduledoc """
  The Paths context.
  """

  import Ecto.Query, warn: false
  alias Talar.Repo
  alias Talar.Paths.Directory
  require Logger

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
  Returns the parent directory.

  ## Examples

      iex> parent_dir("/drab/elixir")
      [%Directory{}, ...]

  """
  def parent_dir(dir) do
    #    Directory
    #    |> where([d], d.dir == ^dir)
    #    |> select([d], {d.dir})
    #    |> Repo.all
    query =
      from Directory,
        where: [dir: ^dir],
        select: [:id, :dir]

    Repo.all(query)
  end

  @doc """
  Returns the parent directory.

  ## Examples

      iex> parent_dir2(27)
      [%Directory{}, ...]

  """
  def parent_dir2(directory_id) do
    #    Directory
    #    |> where([d], d.dir == ^dir)
    #    |> select([d], {d.dir})
    #    |> Repo.all
    # query =
    #   from Directory,
    #   where: [directory_id: ^directory_id],
    #   select: [:id, :dir]
    # Repo.all(query)
    parent_dir2_p(directory_id, "")
  end

  defp parent_dir2_p(dir_id, accumulator) do
    query =
      from Directory,
        where: [id: ^dir_id],
        select: [:id, :dir, :directory_id]

    case Repo.all(query) do
      [] ->
        accumulator

      [directory] ->
        if is_nil(directory.directory_id) do
          accumulator
        else
          parent_dir2_p(directory.directory_id, "/" <> directory.dir <> accumulator)
        end
    end
  end

  @doc """
  Returns the parent directory.

  ## Examples

      iex> list_dir("/drab/elixir")
      [%Directory{}, ...]

  """
  def list_dir(dir) do
    query =
      from Directory,
        where: [directory_id: ^dir.id],
        select: [:id, :dir, :directory_id]

    Repo.all(query)
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
    Logger.info("CREATE #{inspect(attrs)}")

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
