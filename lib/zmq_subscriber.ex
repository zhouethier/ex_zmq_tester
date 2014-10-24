defmodule ZmqSubscriber do
  use GenServer
  require Logger
  # alias ZmqInterface.State

  # @ip "127.0.0.1"
  @sub_port "31285"

  defmodule State do
    defstruct socket: nil, data: []
  end

  # public API
  def start_link(), do: start_link(%{})
  def start_link(args) do
    GenServer.start_link(__MODULE__, [args])
  end

  # GenServer Interface
  def init([args]) do
    port = Map.get(args, :port, @sub_port)
    {:ok, context} = :erlzmq.context()
    {:ok, zmq_subscriber} = :erlzmq.socket(context, [:sub, {:active, true}])
    :ok = :erlzmq.setsockopt(zmq_subscriber, :subscribe, <<>>)
    sub_addr = 'tcp://*:#{port}'
    :ok = :erlzmq.bind(zmq_subscriber, sub_addr)

    # loop(zmq_subscriber)

    Logger.debug "starting zmq_subscriber, binding to #{inspect sub_addr}"
    # {:ok, %State{subscriber: zmq_subscriber}}
    {:ok, %State{socket: zmq_subscriber}}
  end

  def handle_info(data = {:zmq, _socket, msg, [:rcvmore | _rest]}, state) do
    Logger.debug "ZmqSubscriber: rcvmore data: #{inspect data}"
    {:noreply, %State{state | data: [msg | state.data]}}
  end

  def handle_info(data = {:zmq, _socket, msg, _options}, state) do
    Logger.debug "ZmqSubscriber: handle incoming zmq_msg #{inspect data}"
    Logger.debug "ZmqSubscriber: message: #{inspect Enum.reverse([msg | state.data])}"
    {:noreply, %State{state | data: []}}
  end

  def handle_info(msg, state) do
    Logger.debug "ZmqSubscriber: handle incoming msg #{inspect msg}"
    {:noreply, state}
  end

  # private API
  # defp loop(sub) do
  #   {ok, data} = :erlzmq.recv(sub)
  #   Logger.debug "ZmqSubscriber, recv data #{inspect data}"

  #   loop(sub)
  # end
end
