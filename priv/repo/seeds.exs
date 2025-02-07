# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Talar.Repo.insert!(%Talar.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# alias Talar.Repo
alias Talar.Paths.Directory
# alias Talar.Paths

require Logger

Talar.Repo.delete_all(Directory)
Talar.Repo.insert!(%Directory{path: "/"})
# , directory_id: inserted.id})
# {:ok, directory} = Paths.create_directory(%{path: "/"})
# Logger.info("directory: #{inspect(directory)}")
# if Directory.is_root(directory) do
#   Logger.info("Directory: root")
#   Logger.info("PATH: #{inspect(directory.id)}")
#   update = Directory.update_directory(directory, %{directory_id: directory.id})
#   Logger.info("directory: #{inspect(update)}")
# end

# {:ok, %Talar.Directory{id: path_id}} = directory

# Logger.info("directory: #{inspect(directory)}")
# Logger.info("path_id: #{inspect(path_id)}")

# {:ok, dd} = directory
# Logger.info("dd: #{inspect(dd)}")

# what = Directory.update_directory(dd, %{directory_id: path_id})
# Logger.info("what: #{inspect(what)}")
# Directory. create_directory(%{})
