defmodule TalarWeb.DirectoryControllerTest do
  use TalarWeb.ConnCase

  # import Talar.PathsFixtures
  alias Talar.Paths.Directory

  @create_attrs %{directory_name: "some_path", directory_id: 1}
  @update_attrs %{directory_name: "some_updated_path"}
  @invalid_attrs %{directory_name: "another path", directory_id: 1}

  describe "index" do
    test "lists all directories", %{conn: conn} do
      conn = get(conn, ~p"/directories")
      assert_raise(RuntimeError, fn -> html_response(conn, 200) end)
    end
  end

  describe "dir/" do
    setup [:add_user]

    test "list dir on /", %{conn: conn} do
      # IO.inspect(conn)
      conn = get(conn, ~p"/dir")
      assert html_response(conn, 200) =~ "Listing Directories"
    end

    test "list dir on /elixir", %{conn: conn} do
      Talar.Repo.delete_all(Directory)
      %Directory{id: dir_id} = Talar.Repo.insert!(%Directory{directory_name: ""})

      %Directory{} =
        Talar.Repo.insert!(%Directory{directory_name: "elixir", directory_id: dir_id})

      conn = get(conn, ~p"/dir/elixir")
      assert html_response(conn, 200) =~ "Listing Directories"
    end

    test "wrong list dir on /elixir", %{conn: conn} do
      conn = get(conn, ~p"/dir/elixir")
      assert_raise(RuntimeError, fn -> html_response(conn, 200) end)
    end
  end

  describe "new directory" do
    setup [:add_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/directories/new?parent_dir=/&directory_id=1")
      assert html_response(conn, 200) =~ "New Directory"
    end
  end

  describe "create directory" do
    setup [:add_user]

    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post(conn, ~p"/directories?parent_dir=/elixir&directory_id=1", directory: @create_attrs)

      assert %{dir: ["elixir"]} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/dir/elixir"
    end
  end

  describe "update directory" do
    setup [:add_user, :create_directory]

    test "redirects when data is valid", %{conn: conn, dir_id1: dir_id1, dir_id2: dir_id2} do
      conn =
        put(conn, ~p"/directories/#{dir_id2}?parent_dir=/&directory_id=#{dir_id1}",
          directory: @update_attrs
        )

      assert html_response(conn, 200) =~ "some_updated_path"
    end

    test "renders errors when data is invalid", %{conn: conn, dir_id1: dir_id1, dir_id2: dir_id2} do
      conn =
        put(conn, ~p"/directories/#{dir_id2}?parent_dir=/&directory_id=#{dir_id1}",
          directory: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Directory"
    end
  end

  describe "delete directory" do
    setup [:add_user, :create_directory]

    test "deletes chosen directory", %{conn: conn, dir_id1: dir_id1, dir_id2: dir_id2} do
      conn = delete(conn, ~p"/directories/#{dir_id2}?parent_dir=/&directory_id=#{dir_id1}")
      assert redirected_to(conn) == ~p"/dir/"

      # conn = get(conn, ~p"/dir/elixir")
      # assert redirected_to(conn) == ~p"/dir"
    end
  end

  defp create_directory(_) do
    Talar.Repo.delete_all(Directory)
    %Directory{id: dir_id1} = Talar.Repo.insert!(%Directory{directory_name: ""})
    %Directory{id: dir_id2} = Talar.Repo.insert!(%Directory{directory_name: "elixir"})
    %{dir_id1: dir_id1, dir_id2: dir_id2}
  end

  defp add_user(%{conn: conn}) do
    user = Talar.TestHelper.insert_user()
    conn = assign(conn, :current_user, user)
    {:ok, conn: conn, user: user}
  end
end
