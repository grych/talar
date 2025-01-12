defmodule TalarWeb.DirectoryControllerTest do
  use TalarWeb.ConnCase

  import Talar.PathsFixtures

  @create_attrs %{dir: "some dir"}
  @update_attrs %{dir: "some updated dir"}
  @invalid_attrs %{dir: nil}

#  describe "index" do
#    test "lists all directories", %{conn: conn} do
#      conn = get(conn, ~p"/directories")
#      assert html_response(conn, 200) =~ "Listing Directories"
#    end
#  end

  describe "new directory" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/directories/new")
      assert html_response(conn, 200) =~ "New Directory"
    end
  end

  describe "create directory" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/directories", directory: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/directories/#{id}"

      conn = get(conn, ~p"/directories/#{id}")
      assert html_response(conn, 200) =~ "Directory #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/directories", directory: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Directory"
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
      assert html_response(conn, 200) =~ "some updated dir"
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
