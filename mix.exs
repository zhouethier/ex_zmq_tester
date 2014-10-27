defmodule ExZmqTester.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_zmq_tester,
     version: "0.0.1",
     elixir: ">= 1.0.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger],
     included_applications: [:libprotobuf, :erlzmq]
		]
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
    {:libprotobuf, git: "https://github.com/TensorWrench/libprotobuf.git"},
		{:erlzmq, git: "https://github.com/zeromq/erlzmq2.git"},
		{:exprotobuf, "~> 0.8.3"},
		{:gpb, github: "tomas-abrahamsson/gpb"}
	]
  end
end
