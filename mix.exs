defmodule Feedme.Mixfile do
  use Mix.Project

  def project do
    [app: :feedme,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:sweet_xml, "~> 0.3.0"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:apex, "~>0.3.2"},
      {:httpoison, "~> 0.7.3"},
      {:mock, "~> 0.1.1"}
    ]
  end
end
