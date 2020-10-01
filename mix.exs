defmodule ResuelveAuth.Mixfile do
  use Mix.Project

  def project do
    [
      app: :resuelve_auth,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :plug]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.8"},
      {:poison, "~> 4.0.1"}
    ]
  end
end
