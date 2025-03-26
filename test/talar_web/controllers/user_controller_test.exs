defmodule TalarWeb.UserControllerTest do
  use TalarWeb.ConnCase

  import Talar.AccountsFixtures

  # @create_attrs %{name: "some name", email: "some@name.com"}
  # @update_attrs %{name: "some updated name", email: "some@updated.com"}
  @invalid_attrs %{name: nil, email: nil}

  describe "index" do
    setup [:add_user]

    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/users")
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    setup [:add_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/users/new")
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    setup [:add_user]

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/users", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:add_user, :create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, ~p"/users/#{user}/edit")
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:add_user, :create_user]

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/users/#{user}", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:add_user, :create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/users/#{user}")
      assert redirected_to(conn) == ~p"/users"

      # assert_error_sent 404, fn ->
      #   get(conn, ~p"/users/#{user}")
      # end
    end
  end

  test "should get new", %{conn: conn} do
    conn =
      conn
      |> get(~p"/sessions/new")

    assert html_response(conn, 200)
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp add_user(%{conn: conn}) do
    user = Talar.TestHelper.insert_user()
    conn = assign(conn, :current_user, user)
    {:ok, conn: conn, user: user}
  end

end
