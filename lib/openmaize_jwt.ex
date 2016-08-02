defmodule OpenmaizeJWT do
  @moduledoc """
  Authentication library, using JSON Web Tokens, for Plug-based applications in Elixir.
  """

  use Application

  @doc false
  def start(_type, _args) do
    OpenmaizeJWT.Supervisor.start_link
  end
end
