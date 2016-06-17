defmodule OpenmaizeJWT.Mixfile do
  use Mix.Project

  @version "0.10.2"

  @description """
  JSON Web Token library for use with the Openmaize authentication library.
  """

  def project do
    [app: :openmaize_jwt,
      version: @version,
      elixir: "~> 1.2",
      name: "OpenmaizeJWT",
      description: @description,
      package: package,
      source_url: "https://github.com/riverrun/openmaize_jwt",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps]
  end

  def application do
    [mod: {OpenmaizeJWT, []},
      applications: [:logger, :cowboy, :plug]]
  end

  defp deps do
    [{:cowboy, "~> 1.0"},
     {:plug, "~> 1.1"},
     {:poison, ">= 1.5.0"},
     {:earmark, "~> 0.2", only: :dev},
     {:ex_doc,  "~> 0.12", only: :dev}]
  end

  defp package do
    [maintainers: ["David Whitlock"],
     licenses: ["BSD"],
     links: %{"GitHub" => "https://github.com/riverrun/openmaize_jwt",
      "Docs" => "http://hexdocs.pm/openmaize_jwt"}]
  end
end
