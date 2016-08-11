# OpenmaizeJWT

Authentication library using JSON Web Tokens.

## Upgrading to the newest version

There have been a few changes in the newest version, 1.0.0.
Please check the `UPGRADE_1.0.md` guide in this directory for details.

## Installation

1. Add openmaize_jwt to your `mix.exs` dependencies

  ```elixir
  defp deps do
    [{:openmaize_jwt, "~> 1.0.0"}]
  end
  ```

2. List `:openmaize_jwt` as an application dependency

  ```elixir
  def application do
    [applications: [:logger, :openmaize_jwt]]
  end
  ```

## Use

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
