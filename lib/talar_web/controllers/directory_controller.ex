defmodule TalarWeb.DirectoryController do
  use TalarWeb, :controller

  alias Talar.Paths
  alias Talar.Paths.Directory

  def index(conn, dir) do
    %{"dir" => d} = dir
    IO.puts(" #{inspect(d)}")
    # directories = Paths.list_directories(d)
    d = Enum.join(d, "/")
    IO.puts(" #{inspect(d)}")
    d = "/" <> d
    IO.puts(" #{inspect(d)}")
    directories = Paths.list_directories(d)
    if directories == [] do
      IO.puts("  DIRECTORIES!!!  #{inspect(directories)}")
      conn
      |> put_flash(:error, "Cannot change directory to " <> d)
      |> redirect(to: ~p"/dir")
    else
      IO.puts("  DIRECTORIES!!!@@@@@@@@@@@@@@@@@@@@@@  #{inspect(directories)}")
      render(conn, :index, directories: directories, dir: d)
    end
  end

  @spec new(Plug.Conn.t(), any()) :: Plug.Conn.t()
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
