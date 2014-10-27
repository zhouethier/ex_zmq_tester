defmodule ZmqPublisher do
  use GenServer
  require Logger
  # alias ZmqInterface.State 

  @default_ip "127.0.0.1"
  @sub_port "31285"

  # public API
  def start_link(), do: start_link(%{})
  def start_link(args) do
    GenServer.start_link(__MODULE__, [args], [name: PUB])
  end

  def send(pid, msg) when is_binary(msg) do
    GenServer.cast(pid, {:send, msg})
  end

  # GenServer Interface
  def init([args]) do
    ip = Map.get(args, :ip, @default_ip)
    port = Map.get(args, :port, @sub_port)
    {:ok, context} = :erlzmq.context()
    {:ok, zmq_publisher} = :erlzmq.socket(context, [:pub])
    pub_addr = 'tcp://#{ip}:#{port}'
    :ok = :erlzmq.connect(zmq_publisher, pub_addr)	

    Logger.debug "starting publisher, connect to #{inspect pub_addr}"
    {:ok, zmq_publisher}
  end

  def handle_cast({:send, msg}, zmq_publisher) do
    Logger.debug "ZmqPublisher: handle send... message #{inspect msg}, socket #{inspect zmq_publisher}"	
    :ok = :erlzmq.send(zmq_publisher, "header", [:sndmore])
    :ok = :erlzmq.send(zmq_publisher, msg)

    {:noreply, zmq_publisher}
  end

end
