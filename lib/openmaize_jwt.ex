defmodule OpenmaizeJWT do
  @moduledoc """
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
