defmodule TalarWeb.DirectoryController do
  use TalarWeb, :controller

  alias Talar.Paths
  alias Talar.Paths.Directory
  # import Ecto.Changeset
  import Ecto.Query, warn: false

  def list_directory(conn, params) do
    # so params have a "dir" inside:
    #     %{"dir" => ["vaiue1", "value2"]}
    %{"dir" => dir_list} = params
    # so we take the dir list, and then move it to the dirs string
    dirs = if dir_list == [] do
      "/"
    else
      "/" <> Enum.join(dir_list, "/")
    end

    # IO.inspect(dirs)

    case Paths.list_directory(dirs) do
      {:ok, id} ->
        directory = Paths.list_directories(id)
        render(conn, :list_directory, directories: directory, parent_dir: dirs, directory_id: id)
      {:error, _what} -> conn
        |> put_flash(:error, "Can't change directory to #{dirs}.")
        |> redirect(to: ~p"/dir")
    end
  end

  def index(conn, _params) do
    directories = Paths.list_directories()
    render(conn, :index, directories: directories)
  end

  def new(conn, params) do
    %{"parent_dir" => dirs, "directory_id" => directory_id} = params
      changeset = Paths.change_directory(%Directory{})
      render(conn, :new, changeset: changeset, parent_dir: dirs, directory_id: directory_id)
    # end
  end

  def create(conn, %{"directory" => directory_params, "parent_dir" => parent_dir, "directory_id" => directory_id}) do
    # IO.puts("PARENT DIR: #{inspect(parent_dir)}")

    case Paths.create_directory(directory_params) do
      {:ok, _directory} ->
        conn
        |> put_flash(:info, "Directory created successfully.")
        |> redirect(to: "/dir#{parent_dir}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset, parent_dir: parent_dir, directory_id: directory_id)
    end
  end


  def edit(conn, %{"id" => id}) do
    directory = Paths.get_directory!(id)
    changeset = Paths.change_directory(directory)
    render(conn, :edit, directory: directory, changeset: changeset)
  end

  def update(conn, %{"id" => id, "directory" => directory_params, "parent_dir" => parent_dir}) do
    # IO.inspect(parent_dir)
    directory = Paths.get_directory!(id)

    case Paths.update_directory(directory, directory_params) do
      {:ok, _directory} ->
        conn
        |> put_flash(:info, "Directory updated successfully.")
        |> redirect(to: "/dir#{parent_dir}")

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
    |> redirect(to: ~p"/dir/#{parent_dir}")
  end
end
