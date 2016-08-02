defmodule OpenmaizeJWT.Verify do
  @moduledoc """
  Module to verify JSON Web Tokens.
  """

  import Base
  import OpenmaizeJWT.Tools
  alias OpenmaizeJWT.LogoutManager

  @doc """
  Decode the JWT and check that it is valid.

  As well as checking that the token is a valid JWT, this function also
  checks that it has  an `id` and valid `nbf` and `exp` values in the body,
  and that it uses a supported algorithm, either HMAC-sha512 or HMAC-sha256.
  """
  def verify_token(token, secret) do
    case LogoutManager.query_jwt(token) do
      false -> :binary.split(token, ".", [:global]) |> check_valid(secret)
      _ -> {:error, "Already logged out"}
    end
  end

  @doc """
  Get the expiration time of the token.
  """
  def exp_value(token) do
    [_, enc_payload, _] = :binary.split(token, ".", [:global])
    %{exp: exp} = to_map(enc_payload)
    exp
  end

  defp check_valid([enc_header, enc_payload, sign], secret) do
    with [header, payload] <- Enum.map([enc_header, enc_payload], &to_map/1),
        {:ok, alg} <- check_header(header),
        :ok <- check_sign(alg, secret, sign, enc_header, enc_payload),
        :ok <- check_payload(payload),
    do: {:ok, payload}
  end

  defp to_map(input) do
    input |> urldec64 |> Poison.decode!(keys: :atoms)
  end
  defp urldec64(data) do
    data <> case rem(byte_size(data), 4) do
      2 -> "=="
      3 -> "="
      _ -> ""
    end |> url_decode64!
  end

  defp check_header(%{alg: alg, typ: "JWT"}) do
    case alg do
      "HS512" -> {:ok, :sha512}
      "HS256" -> {:ok, :sha256}
      other -> {:error, "The #{other} algorithm is not supported"}
    end
  end
  defp check_header(_), do: {:error, "Invalid header"}

  defp check_sign(alg, secret, sign, enc_header, enc_payload) do
    if sign |> urldec64 == get_mac(enc_header <> "." <> enc_payload, alg, secret) do
      :ok
    else
      {:error, "Invalid token"}
    end
  end

  defp check_payload(%{id: _id, exp: exp, nbf: nbf}) do
    case nbf < System.system_time(:milli_seconds) do
      true -> exp > System.system_time(:milli_seconds) and :ok || {:error, "The token has expired"}
      _ -> {:error, "The token cannot be used yet"}
    end
  end
  defp check_payload(_), do: {:error, "Incomplete token"}
end
