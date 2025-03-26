defmodule Talar.TestHelper do
  alias Talar.Repo

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{
      name: "some name",
      email: "grych@tg.pl",
      password: "password",
      password_confirmation: "password"
    }, attrs)

    %Talar.Accounts.User{}
    |> Talar.Accounts.User.changeset(changes)
    |> Repo.insert!()
  end
end
