defmodule Talar.PathsTest do
  use Talar.DataCase

  alias Talar.Paths
  require Logger

  describe "directories" do
    alias Talar.Paths.Directory

    # import Talar.PathsFixtures

    @invalid_attrs %{dir: nil}

    # test "list_directories/0 returns all directories" do
    #   directory = directory_fixture()
    #   # IO.inspect([directory])
    #   [_ | tail] = Paths.list_directories()
    #   # IO.inspect(tail)
    #   assert tail == [directory]
    # end

    # test "get_directory!/1 returns the directory with given id" do
    #   directory = directory_fixture()
    #   assert Paths.get_directory!(directory.id) == directory
    # end

    # test "create_directory/1 with valid data creates a directory" do
    #   valid_attrs = %{dir: "some dir"}

    #   assert {:ok, %Directory{} = directory} = Paths.create_directory(valid_attrs)
    #   assert directory.dir == "some dir"
    # end

    test "create_directory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Paths.create_directory(@invalid_attrs)
    end

    # test "update_directory/2 with valid data updates the directory" do
    #   directory = directory_fixture()
    #   update_attrs = %{dir: "some updated dir"}

    #   assert {:ok, %Directory{} = directory} = Paths.update_directory(directory, update_attrs)
    #   assert directory.dir == "some updated dir"
    # end

    test "parent_dir/1 will valid the given directory" do
      update_attrs = "/"

      directory = List.first(Paths.parent_dir(update_attrs))
      assert directory.dir == "/"
    end

    test "parent_dir/1 will not be valid the nonexistent directory" do
      update_attrs = "drab"

      # it should be nil
      assert [] = Paths.parent_dir(update_attrs)
    end

    test "parent_dir2/1 will be valid but return ''" do
      update_attrs = -1
      # it should be ""
      assert "" = Paths.parent_dir2(update_attrs)
    end

    test "parent_dir2/1 will be valid" do
      directory = Talar.Repo.insert!(%Directory{dir: "/"})
      # it should be "/"
      assert "/" = Paths.parent_dir2(directory.id)
    end

    test "parent_dir2/1 of two will be valid" do
      directory = Talar.Repo.insert!(%Directory{dir: "/"})
      directory = Talar.Repo.insert!(%Directory{dir: "drab", directory_id: directory.id})
      # it should be "/"
      assert "/drab/" = Paths.parent_dir2(directory.id)
    end

    test "parent_dir2/1 of three will be valid" do
      directory = Talar.Repo.insert!(%Directory{dir: "/"})
      directory = Talar.Repo.insert!(%Directory{dir: "drab", directory_id: directory.id})
      directory = Talar.Repo.insert!(%Directory{dir: "marmolada", directory_id: directory.id})
      # IO.puts("SECOND PARENT #{inspect(directory)}")
      # it should be "/"
      assert "/drab/marmolada/" = Paths.parent_dir2(directory.id)
    end

    test "list_dir/1" do
      directory = Talar.Repo.insert!(%Directory{dir: "/"})
      Talar.Repo.insert!(%Directory{dir: "drab", directory_id: directory.id})
      Talar.Repo.insert!(%Directory{dir: "marmolada", directory_id: directory.id})
      Talar.Repo.insert!(%Directory{dir: "another_dir", directory_id: directory.id})
      Talar.Repo.insert!(%Directory{dir: "another_dir2", directory_id: directory.id})
      # IO.puts("SECOND PARENT #{inspect(directory)}")
      Paths.list_dir("///drab/marmolada//")
    end

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
