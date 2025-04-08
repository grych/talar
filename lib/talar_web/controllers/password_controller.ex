defmodule TalarWeb.PasswordController do
  use TalarWeb, :controller

  alias Talar.Paths
  alias Talar.Paths.Password

  import Ecto.Query, warn: false

  plug :authenticate
       when action in [:new, :create]

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: ~p"/sessions/new")
      |> halt()
    end
  end

  def new(conn, params) do
    %{"parent_dir" => dirs, "directory_id" => directory_id} = params
    changeset = Paths.change_password(%Password{})
    render(conn, :new, changeset: changeset, parent_dir: dirs, directory_id: directory_id)
  end

  def create(conn, %{
        "password" => password_params,
        "parent_dir" => parent_dir,
        "directory_id" => directory_id
      }) do
    # IO.puts("PARENT DIR: #{inspect(parent_dir)}")

    case Paths.create_password(password_params) do
      {:ok, _directory} ->
        conn
        |> put_flash(:info, "Password created successfully.")
        |> redirect(to: "/dir#{parent_dir}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new,
          changeset: changeset,
          parent_dir: parent_dir,
          directory_id: directory_id
        )
    end
  end

end
