# OpenmaizeJWT

JSON Web Token library for use with the Openmaize authentication library.

## Installation

1. Add openmaize_jwt to your `mix.exs` dependencies

  ```elixir
  defp deps do
    [{:openmaize_jwt, "~> 0.12"}]
  end
  ```

2. List `:openmaize_jwt` as an application dependency

  ```elixir
  def application do
    [applications: [:logger, :openmaize_jwt]]
  end
  ```
