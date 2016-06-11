defmodule OpenmaizeJWT.Config do
  @moduledoc """
  This module provides an abstraction layer for configuration.

  The following are valid configuration items.

  | name               | type    | default  |
  | :----------------- | :------ | -------: |
  | token_alg          | atom    | :sha512  |
  | token_validity     | int     | 120 (minutes)  |
  | token_data         | list    | []       |
  | keyrotate_days     | int     | 28       |

  ## Examples

  The simplest way to change the default values would be to add
  an `openmaize_jwt` entry to the `config.exs` file in your project,
  like the following example.

      config :openmaize_jwt,
        token_alg: :sha256,
        token_validity: 60,
        token_data: [:iss, :aud],
        keyrotate_days: 7
  """

  @doc """
  The algorithm used to sign the token.

  The default value is :sha512, and :sha256 is also supported.
  """
  def get_token_alg do
    case token_alg do
      :sha256 -> {"HS256", :sha256}
      _ -> {"HS512", :sha512}
    end
  end
  defp token_alg do
    Application.get_env(:openmaize_jwt, :token_alg, :sha512)
  end

  @doc """
  The length of time after which a JSON Web Token expires.

  The default length of time is 120 minutes (2 hours).
  """
  def token_validity do
    Application.get_env(:openmaize_jwt, :token_validity, 120)
  end

  @doc """
  Additional information to be added to the token.

  This needs to be a list of atoms. The default is an empty list.
  Each atom in the list should be in the database user model. If any
  entry in the list is not in the user model, it will be ignored.

  ## Warning

  Do not include any sensitive data in the JSON Web Token.
  """
  def token_data do
    Application.get_env(:openmaize_jwt, :token_data, [])
  end

  @doc """
  The number of days after which the JWT signing keys will be rotated.
  """
  def keyrotate_days do
    Application.get_env(:openmaize_jwt, :keyrotate_days, 28)
  end
end
