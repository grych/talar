defmodule Talar.PathsTest do
  # alias Talar.Paths.Directory
  use Talar.DataCase

  alias Talar.Paths

  describe "directories" do
    alias Talar.Paths.Directory

    import Talar.PathsFixtures

    @invalid_attrs %{path: nil, directory_id: nil}

    test "list_directories/1 should return [], if there is a parent directory" do
      Talar.Repo.insert!(%Directory{path: "/drab"})
      assert Paths.list_directories("/drab") == []
    end

    test "list_directories/1 returns all directories from the current (parent) dir" do
      directory = Talar.Repo.insert!(%Directory{path: "/drab"})
      directory2 = Talar.Repo.insert!(%Directory{path: "/drab/whatever", directory_id: directory.id})
      directory3 = Talar.Repo.insert!(%Directory{path: "/drab/whatever2", directory_id: directory.id})
      # IO.inspect(Paths.list_directories("/drab"))
      list_directories = Paths.list_directories("/drab")
      dir = hd(list_directories)
      assert directory2.path == dir.path
      [dir] = tl(list_directories)
      assert directory3.path == dir.path
    end

    test "get_directory!/1 returns the directory with given id" do
      directory = directory_fixture()
      assert Paths.get_directory!(directory.id) == directory
    end

    # test "create_directory/1 with valid data creates a directory" do
    #   valid_attrs = %{path: "some path", directory_id: 42}

    #   assert {:ok, %Directory{} = directory} = Paths.create_directory(valid_attrs)
    #   assert directory.path == "some path"
    #   assert directory.directory_id == 42
    # end

    test "create_directory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Paths.create_directory(@invalid_attrs)
    end

    # test "update_directory/2 with valid data updates the directory" do
    #   directory = directory_fixture()
    #   update_attrs = %{path: "some updated path", directory_id: 43}

    #   assert {:ok, %Directory{} = directory} = Paths.update_directory(directory, update_attrs)
    #   assert directory.path == "some updated path"
    #   assert directory.directory_id == 43
    # end

    # test "update_directory/2 with invalid data returns error changeset" do
    #   directory = directory_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Paths.update_directory(directory, @invalid_attrs)
    #   assert directory == Paths.get_directory!(directory.id)
    # end

    # test "delete_directory/1 deletes the directory" do
    #   directory = directory_fixture()
    #   assert {:ok, %Directory{}} = Paths.delete_directory(directory)
    #   assert_raise Ecto.NoResultsError, fn -> Paths.get_directory!(directory.id) end
    # end

    # test "change_directory/1 returns a directory changeset" do
    #   directory = directory_fixture()
    #   assert %Ecto.Changeset{} = Paths.change_directory(directory)
    # end
  end
end
