defmodule TalarWeb.DirectoryController do
  use TalarWeb, :controller

  alias Talar.Paths
  alias Talar.Paths.Directory
  import Ecto.Changeset
  import Ecto.Query, warn: false

  def get_parent(conn, params) do
    # so params have a "dir" inside:
    #     %{"dir" => ["vaiue1", "value2"]}
    %{"dir" => dir_list} = params
    # so we take the dir list, and then move it to the dirs string
    dirs = if dir_list == [] do
      "/"
    else
      Enum.join(dir_list, "/")
    end
    # we are checking if it exists?
    query = from d in Directory, where: d.path == ^dirs
    if Talar.Repo.exists?(query) do
      directories = Paths.list_directories(dirs)
      render(conn, :get_parent, directories: directories, parent_dir: dirs)
    else
      conn
      |> put_flash(:error, "Can't change directory to #{dirs}.")
      |> redirect(to: ~p"/dir")
    end
  end

  def index(conn, _params) do
    directories = Paths.list_directories()
    render(conn, :index, directories: directories)
  end

  def new(conn, params) do
    %{"parent_dir" => dirs} = params
    query =
      from Directory,
        where: [path: ^dirs],
        select: [:id, :directory_id, :path]
    if (list = Talar.Repo.all(query)) == [] do
      conn
      |> put_flash(:error, "Can't change directory to #{dirs}, does not exits.")
      |> redirect(to: ~p"/dir")
    else
      changeset = Paths.change_directory(%Directory{})
      # whatever, any case contains the same id as it the is "new"
      directory_id = List.first(list).id
      render(conn, :new, changeset: changeset, parent_dir: dirs, directory_id: directory_id)
    end
  end

  def create(conn, %{"directory" => directory_params, "parent_dir" => parent_dir, "directory_id" => directory_id}) do
    IO.puts("PARENT DIR: #{inspect(parent_dir)}")
    IO.puts("directory DIR: #{inspect(directory_id)}")

    case Paths.create_directory(directory_params) do
      {:ok, directory} ->
        conn
        |> put_flash(:info, "Directory created successfully.")
        |> redirect(to: ~p"/dir/#{directory.path}")

      {:error, %Ecto.Changeset{} = changeset} ->
        # path = get_field(changeset, :path)
        # IO.puts("WHA?  #{path}")
        # dir = Talar.Repo.get_by!(Directory, path: path)
        # IO.puts("WHA?  inspect(#{dir})")
        # put_change(changeset, :name, "///")
        # id = if path == nil do "" else path end
        # path = if path == "/" do "" else path end
        # directory_parent = Paths.get_directory!(id)
        # parent_dir_path = if directory_parent == nil do "/" else directory_parent.path end
        # changeset = Map.put(changeset.data, :parent_dir, directory_parent.path)
        render(conn, :new, changeset: changeset, parent_dir: parent_dir, directory_id: directory_id)
    end
  end

  def show(conn, %{"id" => id}) do
    directory = Paths.get_directory!(id)
    render(conn, :show, directory: directory)
  end

  def edit(conn, %{"id" => id}) do
    directory = Paths.get_directory!(id)
    directory_parent = Paths.get_directory!(directory.directory_id)
    # parent_dir_path = if directory_parent == nil do "/" else directory_parent.path end
    directory = Map.put(directory, :parent_dir_path, directory_parent.path)
    # IO.inspect(directory)
    changeset = Paths.change_directory(directory)
    render(conn, :edit, directory: directory, changeset: changeset)
  end

  def update(conn, %{"id" => id, "directory" => directory_params}) do
    directory = Paths.get_directory!(id)
    # IO.inspect(directory)
    directory_parent = Paths.get_directory!(directory.directory_id)
    # parent_dir_path = if directory_parent == nil do "/" else directory_parent.path end
    directory = Map.put(directory, :parent_dir_path, directory_parent.path)

    case Paths.update_directory(directory, directory_params) do
      {:ok, directory} ->
        conn
        |> put_flash(:info, "Directory updated successfully.")
        |> redirect(to: ~p"/dir/#{directory.parent_dir_path}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, directory: directory, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    directory = Paths.get_directory!(id)
    parent_dir = Paths.get_directory!(directory.directory_id)
    {:ok, _directory} = Paths.delete_directory(directory)

    conn
    |> put_flash(:info, "Directory deleted successfully.")
    |> redirect(to: ~p"/dir/#{parent_dir.path}")
  end
end
