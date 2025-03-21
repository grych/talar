defmodule TalarWeb.SessionsController do
  use TalarWeb, :controller

  alias Talar.Accounts
  alias Talar.Accounts.User

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, _) do
    render(conn, :create)
  end
end
