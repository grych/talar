defmodule Talar.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Talar.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some@name.com",
        name: "some name",
        password: "Foo22Bar!",
        password_confirmation: "Foo22Bar!"
      })
      |> Talar.Accounts.create_user()

    user
  end
end
