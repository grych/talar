defmodule TalarWeb.DirectoryController do
  use TalarWeb, :controller

  alias Talar.Paths
  alias Talar.Paths.Directory

  require Logger

  def index(conn, params) do
    %{"dir" => params} = params
    params = "/" <> Enum.join(params, "/")
    Logger.info("#{inspect(params)}")
    directories = Paths.list_dirs(params)
    Logger.info("#{inspect(directories)}")
    case directories do
      [] ->
        conn
        |> put_flash(:error, "Cannot change directory to " <> params)
        |> redirect(to: ~p"/dir")
      [dir] -> render(conn, :index, directories: [dir])
    end
    #render(conn, :index, directories: directories)
  end

  def new(conn, _params) do
    changeset = Paths.change_directory(%Directory{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"directory" => directory_params}) do
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
