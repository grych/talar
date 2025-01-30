defmodule TalarWeb.DirectoryController do
  use TalarWeb, :controller

  alias Talar.Paths
  alias Talar.Paths.Directory

  require Logger

  def index(conn, parent_dir) do
    Logger.info("FIRST PARENT_DIR #{inspect(parent_dir)}")
    # %{"dir" => parent_dir} = parent_dir
    # Logger.info("PARENT_DIR #{inspect(parent_dir)}")
    # dirs = "/" <> Enum.join(parent_dir, "/")
    # Logger.info("DIR: #{inspect(dirs)}")
    # directories = Paths.parent_dir(dirs)
    # Logger.info("DIRECTORY: #{inspect(directories)}")
    %{"dir" => dirs} = parent_dir
    Logger.info("DIRS #{inspect(dirs)}")
    dirs = if dirs == [] do
        "/"
    end
    Logger.info("SECOND DIRS #{inspect(dirs)}")
    # directories = Paths.list_dir(dirs)
    # Logger.info("DIRECTORies #{inspect(directories)}")
    # directory = %Directory{}
    directories = Paths.list_dir(dirs)
    Logger.info("DIRECTORIES #{inspect(directories)}")
    case directories do
      "" ->
        conn
        |> put_flash(:error, "Cannot change directory to " <> dirs)
        |> redirect(to: ~p"/dir")

      directories ->
        render(conn, :index, directories: directories)
    end
  end

  def new(conn, parent_dir) do
    Logger.info("SECOND PARENT #{inspect(parent_dir)}")
    %{"parent_dir" => parent_dir} = parent_dir
    parent_dir = Paths.parent_dir(parent_dir)

    case parent_dir do
      [] ->
        conn
        |> put_flash(:error, "Cannot change directory")
        |> redirect(to: ~p"/dir")

      [directories] ->
        Logger.info("SECOND PARENT 2 #{inspect(directories.id)}")
        changeset = Paths.change_directory(%Directory{})
        # changeset = Ecto.Changeset.put_change(changeset, parent_dir: parent_dir)
        render(conn, :new, parent_dir: directories.id, changeset: changeset)
    end
  end

  def create(conn, directory_params) do
    # Logger.info("create PARENT #{inspect(parent_dir)}")
    Logger.info("create directory_params #{inspect(directory_params)}")

    case Paths.create_directory(directory_params) do
      {:ok, directory} ->
        conn
        |> put_flash(:info, "Directory created successfully.")
        |> redirect(to: ~p"/directories/#{directory}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    directory = Paths.get_directory!(id)
    render(conn, :show, directory: directory)
  end

  def edit(conn, %{"id" => id}) do
    directory = Paths.get_directory!(id)
    changeset = Paths.change_directory(directory)
    render(conn, :edit, directory: directory, changeset: changeset)
  end

  def update(conn, %{"id" => id, "directory" => directory_params}) do
    directory = Paths.get_directory!(id)

    case Paths.update_directory(directory, directory_params) do
      {:ok, directory} ->
        conn
        |> put_flash(:info, "Directory updated successfully.")
        |> redirect(to: ~p"/directories/#{directory}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, directory: directory, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    directory = Paths.get_directory!(id)
    {:ok, _directory} = Paths.delete_directory(directory)

    conn
    |> put_flash(:info, "Directory deleted successfully.")
    |> redirect(to: ~p"/directories")
  end
end
