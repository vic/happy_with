defmodule HappyWith.Mixfile do
  use Mix.Project

  def project do
    [app: :happy_with,
     version: "1.0.0",
     elixir: "~> 1.2",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def package do
    [files: ~w(lib mix.exs README* LICENSE),
     maintainers: ["Victor Hugo Borja <vborja@apache.org>"],
     licenses: ["Apache 2.0"],
     links: %{
       "GitHub" => "https://github.com/vic/happy_with"
     }]
  end

  def description do
    """
    Tiny syntax sugar around Elixir's `with` special form.

    Dont use commas around with expressions.
    """
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
