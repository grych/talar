defmodule Talar.Crypto do
  @moduledoc """
  Functions related to encrypting and decrypting data using the Advanced
  Encryption Standard (AES).
  """
  @block_size 16

  @doc """
  Encrypt the given `data` with AES-256 in CBC mode using given key and `iv`
  PKCS#7 padding will be added to `data`
  """
  def encrypt(plain_text, key) do
    secret_key_hash = make_hash(key, 32)

    # create Initialisation Vector
    iv = :crypto.strong_rand_bytes(@block_size)

    padded_text = pad_pkcs7(plain_text, @block_size)
    encrypted_text = :crypto.crypto_one_time(:aes_256_cbc, secret_key_hash, iv, padded_text, true)

    # concatenate IV for decryption
    encrypted_text = iv <> encrypted_text

    Base.encode64(encrypted_text)
  end

  @doc """
  Decrypt the given `data` with AES-256 in CBC mode using given key and `iv`
  PKCS#7 padding will be removed
  """
  def decrypt(cipher_text, key) do
    secret_key_hash = make_hash(key, 32)

    {:ok, ciphertext} = Base.decode64(cipher_text)
    <<iv::binary-16, ciphertext::binary>> = ciphertext
    decrypted_text = :crypto.crypto_one_time(:aes_256_cbc, secret_key_hash, iv, ciphertext, false)

    unpad_pkcs7(decrypted_text)
  end

  @doc """
  Pad the `message` by extending it to the nearest `blocksize` boundary,
  appending the number of bytes of padding to the end of the block.
  If the original `message` is a multiple of `blocksize`, an additional block
  of bytes with value `blocksize` is added.
  ## Examples
       iex> Talar.Crypto.pad_pkcs7("HELLO", 16)
       <<72, 69, 76, 76, 79, 3, 3, 3>>
       iex> Talar.Crypto.pad_pkcs7("HELLO", 16)
       <<72, 69, 76, 76, 79, 5, 5, 5, 5, 5>>
  """
  def pad_pkcs7(message, blocksize) do
    pad = blocksize - rem(byte_size(message), blocksize)
    message <> to_string(List.duplicate(pad, pad))
  end

  @doc """
   Remove the PKCS#7 padding from the end of `data`.
   ## Examples
       iex> Talar.Crypto.unpad_pkcs7(<<72, 69, 76, 76, 79, 3, 3, 3>>)
       "HELLO"
  """
  def unpad_pkcs7(data) do
    <<pad>> = binary_part(data, byte_size(data), -1)
    binary_part(data, 0, byte_size(data) - pad)
  end

  defp make_hash(text, length) do
    :crypto.hash(:sha256, text)
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
