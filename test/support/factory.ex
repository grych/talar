defmodule Talar.Factory do
  use ExMachina.Ecto, repo: Talar.Repo
  use Talar.UserFactory
end
