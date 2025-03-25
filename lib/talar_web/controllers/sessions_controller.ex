defmodule TalarWeb.SessionsController do
  use TalarWeb, :controller

  alias Talar.Accounts
  alias Talar.Accounts.User

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => pass, "save" => save}}) do
    case Talar.Auth.login_by_email_and_password(conn, email, pass) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: ~p"/dir")
      {:error, _, conn} ->
        changeset = Accounts.change_user(%User{email: email})
        conn
        |> put_flash(:error, "Invalid username or password")
        |> render(:new, changeset: changeset)
    end
  end
end
