defmodule OpenmaizeJWT do
  @moduledoc """
  Authentication library, using JSON Web Tokens, for Plug-based applications in Elixir.

  Before you use OpenmaizeJWT, you need to make sure that you have a module
  that implements the Openmaize.Database behaviour. If you are using Ecto,
  you can generate the necessary files by running the following command:

      mix openmaize.gen.ectodb

  To generate modules to handle authorization, and optionally email confirmation,
  run the following command:

      mix openmaize.gen.phoenixauth --api

  You then need to configure OpenmaizeJWT. For more information, see the documentation
  for the OpenmaizeJWT.Config module.

  OpenmaizeJWT uses Openmaize as a dependency. For more information about
  Openmaize, see the documentation for Openmaize, Openmaize.Login,
  Openmaize.OnetimePass, Openmaize.ConfirmEmail and Openmaize.ResetPassword.
  """

  use Application

  @doc false
  def start(_type, _args) do
    OpenmaizeJWT.Supervisor.start_link
  end
end
