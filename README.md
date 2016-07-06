# OpenmaizeJWT

JSON Web Token library for use with the Openmaize authentication library.

## Installation

1. Add openmaize and openmaize_jwt to your `mix.exs` dependencies

  ```elixir
  defp deps do
    [{:openmaize, "~> 1.0"},
    {:openmaize_jwt, "~> 0.12"}]
  end
  ```

2. List `:openmaize` and `:openmaize_jwt` as application dependencies

  ```elixir
  def application do
    [applications: [:logger, :openmaize, :openmaize_jwt]]
  end
  ```
