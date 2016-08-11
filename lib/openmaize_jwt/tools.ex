defmodule OpenmaizeJWT.Tools do
  @moduledoc """
  Various tools that are used with the management of JSON Web Tokens.
  """

  alias OpenmaizeJWT.Config

  @doc """
  Generate a signing salt for use with this module.

  After running gen_key, add the following lines to your config:

      config :openmaize,
        signing_key: "generated key"
  """
  def gen_key(length \\ 64)
  def gen_key(length) when length > 63 do
    :crypto.strong_rand_bytes(length) |> Base.encode64 |> binary_part(0, length)
  end
  def gen_key(_) do
    raise ArgumentError, "The secret should be 64 bytes or longer"
  end

  @doc """
  The hash to be used when checking the signature.
  """
  def get_mac(data, alg) do
    :crypto.hmac(alg, Config.signing_key, data)
  end
end
