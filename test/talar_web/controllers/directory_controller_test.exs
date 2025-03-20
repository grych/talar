defmodule TalarWeb.DirectoryControllerTest do
  use TalarWeb.ConnCase

  import Talar.PathsFixtures
  alias Talar.Paths.Directory

  @create_attrs %{directory_name: "some_path", directory_id: 1}
  @update_attrs %{directory_name: "some_updated_path", directory_id: 33}
  @invalid_attrs %{directory_name: nil, directory_id: nil}

  describe "index" do
    test "lists all directories", %{conn: conn} do
      conn = get(conn, ~p"/directories")
      assert_raise(RuntimeError, fn -> html_response(conn, 200) end)
    end
  end

  describe "dir/" do
    test "list dir on /", %{conn: conn} do
      conn = get(conn, ~p"/dir")
      assert html_response(conn, 200) =~ "Listing Directories"
    end

    test "list dir on /elixir", %{conn: conn} do
      Talar.Repo.delete_all(Directory)
      %Directory{id: dir_id} = Talar.Repo.insert!(%Directory{directory_name: ""})
      %Directory{} = Talar.Repo.insert!(%Directory{directory_name: "elixir", directory_id: dir_id})

      conn = get(conn, ~p"/dir/elixir")
      assert html_response(conn, 200) =~ "Listing Directories"
    end

    test "wrong list dir on /elixir", %{conn: conn} do
      conn = get(conn, ~p"/dir/elixir")
      assert_raise(RuntimeError, fn -> html_response(conn, 200) end)
    end
  end

  describe "new directory" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/directories/new?parent_dir=/&directory_id=1")
      assert html_response(conn, 200) =~ "New Directory"
    end
  end

  describe "create directory" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/directories?parent_dir=/elixir&directory_id=1", directory: @create_attrs)

      assert %{dir: ["elixir"]} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/dir/elixir"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/directories?parent_dir=/elixir&directory_id=22", directory: @invalid_attrs)
      assert_raise(RuntimeError, fn -> html_response(conn, 200) end)
    end
  end

  describe "edit directory" do
    setup [:create_directory]

    test "renders form for editing chosen directory", %{conn: conn, directory: directory} do
      conn = get(conn, ~p"/directories/#{directory}/edit")
      assert html_response(conn, 200) =~ "Edit Directory"
    end
  end

  describe "update directory" do
    setup [:create_directory]

    test "redirects when data is valid", %{conn: conn, directory: directory} do
      conn = put(conn, ~p"/directories/#{directory}", directory: @update_attrs)
      assert redirected_to(conn) == ~p"/directories/#{directory}"

      conn = get(conn, ~p"/directories/#{directory}")
      assert html_response(conn, 200) =~ "some updated path"
    end

    test "renders errors when data is invalid", %{conn: conn, directory: directory} do
      conn = put(conn, ~p"/directories/#{directory}", directory: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Directory"
    end
  end

  describe "delete directory" do
    setup [:create_directory]

    test "deletes chosen directory", %{conn: conn, directory: directory} do
      conn = delete(conn, ~p"/directories/#{directory}")
      assert redirected_to(conn) == ~p"/directories"

      assert_error_sent 404, fn ->
        get(conn, ~p"/directories/#{directory}")
      end
    end
  end

  defp create_directory(_) do
    directory = directory_fixture()
    %{directory: directory}
  end
end
