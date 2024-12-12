defmodule Talar.PathsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Talar.Paths` context.
  """

  @doc """
  Generate a directory.
  """
  def directory_fixture(attrs \\ %{}) do
    {:ok, directory} =
      attrs
      |> Enum.into(%{
        dir: "some dir"
      })
      |> Talar.Paths.create_directory()

    directory
  end
end
