defmodule Messenger.Mixfile do
  use Mix.Project

  def project do
    [
      app: :messenger,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Messenger, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gen_smtp, "~> 0.11.0"}
    ]
  end
end
