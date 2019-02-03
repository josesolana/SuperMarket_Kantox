defmodule Checkout.Mixfile do
  use Mix.Project

  def project do
    [
      app: :supermarkets,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 0.9", only: :dev, runtime: false},
      {:credo, "~> 1.0.1", only: [:dev, :test], runtime: false},
      {:decimal, "~> 1.6"},
    ]
  end
end
