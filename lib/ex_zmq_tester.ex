defmodule ExZmqTester do
  use Application

  # See http://elixir-lang.org/docs/stable/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      worker(ZmqPublisher, [])
      # worker(ZmqSubscriber, []) # we might have other SUB bind to the same port, thus only manually start SUB if needed
    ]

    # See http://elixir-lang.org/docs/stable/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExZmqTester.Supervisor]
    Supervisor.start_link(children, opts)
  end	
end
