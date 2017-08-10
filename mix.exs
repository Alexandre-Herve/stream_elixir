defmodule StreamElixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :stream_elixir,
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
      {:poison, "~> 2.0.0"},
      {:joken, "~> 1.5.0"},
      {:httpotion, "~> 3.0.2"}
    ]
  end

  defp package do
    [files: ~w(lib mix.exs README.md LICENSE VERSION),
    maintainers: ["Devin Torres"],
    licenses: ["CC0-1.0"],
    links: %{"GitHub" => "https://github.com/seanmor5/stream_elixir"}]
  end


end
