# OpenmaizeJWT

JSON Web Token library for use with the Openmaize authentication library.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add openmaize_jwt to your list of dependencies in `mix.exs`:

        def deps do
          [{:openmaize_jwt, "~> 0.11"}]
        end

  2. Ensure openmaize_jwt is started before your application:

        def application do
          [applications: [:openmaize_jwt]]
        end

