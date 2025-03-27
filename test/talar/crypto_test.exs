defmodule Talar.CryptoTest do
  use ExUnit.Case, async: true
  import Talar.Crypto

  describe "crypto" do
    test "encode something" do
      encrypt = encrypt("elixir", "drab")
      decrypt = decrypt(encrypt, "drab")
      assert ("elixir" == decrypt)
    end
  end
end
