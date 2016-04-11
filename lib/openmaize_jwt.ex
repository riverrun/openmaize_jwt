defmodule OpenmaizeJWT do
  @moduledoc """
  JSON Web Token library for use with the Openmaize authentication library.

  ## JSON Web Tokens

  JSON Web Tokens (JWTs) are an alternative to using cookies to identify,
  and provide information about, users after they have logged in.

  One main advantage of using JWTs is that there is no need to keep a
  session store as the token can be used to contain user information.
  It is important, though, not to keep sensitive information in the
  token as the information is not encrypted -- it is just encoded.

  """

  use Application

  @doc false
  def start(_type, _args) do
    OpenmaizeJWT.Supervisor.start_link
  end

  @doc """
  Restart the keymanager child process without keeping state.

  This can be used to remove the old keys and generate new ones.
  After being stopped, the keymanager will be restarted and new keys
  will be created.
  """
  def restart_keymanager do
    Process.whereis(OpenmaizeJWT.KeyManager) |> Process.exit(:kill)
  end
end
