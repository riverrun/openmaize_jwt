defmodule OpenmaizeJWT.Tools do
  @moduledoc """
  Various tools that are used with the management of JSON Web Tokens.
  """

  alias OpenmaizeJWT.Config
  alias Plug.Crypto.KeyGenerator

  @doc """
  Generate a signing salt for use with this module.

  After running gen_salt, add the following lines to your config:

      config :openmaize,
        signing_salt: "generated salt"
  """
  def gen_salt(length \\ 16)
  def gen_salt(length) when length > 15 do
    :crypto.strong_rand_bytes(length) |> Base.encode64 |> binary_part(0, length)
  end
  def gen_salt(_) do
    raise ArgumentError, "The salt should be 16 bytes or longer"
  end

  @doc """
  The hash to be used when checking the signature.
  """
  def get_mac(data, alg, secret) do
    :crypto.hmac(alg, get_key(secret, Config.signing_salt), data)
  end

  @doc """
  """
  def get_key(_, salt) when is_nil(salt) or byte_size(salt) < 16 do
    raise ArgumentError, "You need to set the `signing_salt` config value" <>
    " to a value that is 16 bytes or longer"
  end
  def get_key(secret, _) when  is_nil(secret) or byte_size(secret) < 64 do
    raise ArgumentError, "The secret should be 64 bytes or longer"
  end
  def get_key(secret, salt) do
    KeyGenerator.generate(secret, salt)
  end

end
