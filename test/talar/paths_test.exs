defmodule Talar.PathsTest do
  # alias Talar.Paths.Directory
  use Talar.DataCase

  alias Talar.Paths

  describe "directories" do
    alias Talar.Paths.Directory

    # import Talar.PathsFixtures

    # @invalid_attrs %{directory_name: nil, directory_id: nil}

    test "get_root_directory/0 should return root" do
      assert {:ok, _id} = Paths.get_root_directory()
    end

    test "list_directory/1 should return root" do
      {:ok, _root} = Paths.list_directory("/")
      assert _root = Paths.get_root_directory()
    end

    test "list_directory/1 should return {:ok, is_named_binding()} when they found it"  do
      Talar.Repo.delete_all(Directory)
      %Directory{id: dir_id} = Talar.Repo.insert!(%Directory{directory_name: ""})
      %Directory{id: dir_id} = Talar.Repo.insert!(%Directory{directory_name: "drab", directory_id: dir_id})
      Talar.Repo.insert!(%Directory{directory_name: "elixir", directory_id: dir_id})

      assert {:ok, _id} = Paths.list_directory("///drab///elixir///")
      # IO.inspect(id)
      # assert id != nil

      assert {:ok, _id} = Paths.list_directory("///drab")
      # assert id2 != nil

      assert {:error, _id} = Paths.list_directory("///drab///Elixir///")
      assert {:error, _id} = Paths.list_directory("///Frab///elixir///")
      # IO.inspect(id)
      #  id != nil

      {:ok, _root} = Paths.list_directory("//")
      assert _root = Paths.get_root_directory()
    end

    test "list_directories/1 should return directories" do
      Talar.Repo.delete_all(Directory)
      %Directory{id: dir_id} = Talar.Repo.insert!(%Directory{directory_name: ""})
      %Directory{id: dir_id} = Talar.Repo.insert!(%Directory{directory_name: "drab", directory_id: dir_id})
      Talar.Repo.insert!(%Directory{directory_name: "elixir", directory_id: dir_id})
      # IO.inspect Paths.list_directories(dir_id)
      assert _id = Paths.list_directories(dir_id)
    end

    test "list_directories/1 should return nothing, if there is a parent directory" do
      Talar.Repo.insert!(%Directory{directory_name: "drab"})
      assert_raise Ecto.Query.CastError, fn -> Paths.list_directories("/drab") end
    end

    test "get_directory!/1 returns the directory with given id" do
      directory = Talar.Repo.insert!(%Directory{directory_name: "drab"})
      assert Paths.get_directory!(directory.id) == directory
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
