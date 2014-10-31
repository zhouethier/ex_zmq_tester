defmodule ZmqPublisher do
  use GenServer
  require Logger
  # alias ZmqInterface.State 

  @default_ip "127.0.0.1"
  @pub_port "20174"

  # public API
  def start_link(), do: start_link(%{})
  def start_link(args) do
    GenServer.start_link(__MODULE__, [args], [name: PUB])
  end

  def send(pid, msg) when is_binary(msg) do
    GenServer.cast(pid, {:send, msg})
  end

  def send_multi(pid, hdr, msg) when is_binary(msg) do
    GenServer.cast(pid, {:send_multi, hdr, msg})
  end

  def start_scan(pid) do
    GenServer.cast(pid, {:start_scan})
  end

  def start_scan(pid, config_file) do
    GenServer.cast(pid, {:start_scan, config_file})
  end

  # GenServer Interface
  def init([args]) do
    ip = Map.get(args, :ip, @default_ip)
    port = Map.get(args, :port, @pub_port)
    {:ok, context} = :erlzmq.context()
    {:ok, zmq_publisher} = :erlzmq.socket(context, [:pub])
    pub_addr = 'tcp://#{ip}:#{port}'
    :ok = :erlzmq.connect(zmq_publisher, pub_addr)	

    Logger.debug "starting publisher, connect to #{inspect pub_addr}"
    {:ok, zmq_publisher}
  end

	def handle_cast({:start_scan}, zmq_publisher) do
		Logger.debug "ZmqPublisher: start_scan socket #{inspect zmq_publisher}"	

		msg = ActionMessage.ActionMsg.new(type: :start_scan)
		encoded_msg = ActionMessage.ActionMsg.encode(msg)
		Logger.debug "...send_action_message_out, #{inspect msg}"
 		:ok = :erlzmq.send(zmq_publisher, encoded_msg)

    {:noreply, zmq_publisher}
	end

	def handle_cast({:start_scan, config_file}, zmq_publisher) do
		Logger.debug "ZmqPublisher: start_scan socket #{inspect zmq_publisher}"	
		
		config_content = parse_conf_file(config_file)

		msg = ActionMessage.ActionMsg.new(action_type: :start_scan, configuration_content: config_content, configuration_format: :csv)
		encoded_msg = ActionMessage.ActionMsg.encode(msg)
		Logger.debug "...send_action_message_out, #{inspect msg}"
 		:ok = :erlzmq.send(zmq_publisher, encoded_msg)

    {:noreply, zmq_publisher}
	end

  def handle_cast({:send, msg}, zmq_publisher) do
    Logger.debug "ZmqPublisher: send message #{inspect msg}, socket #{inspect zmq_publisher}"	

    :ok = :erlzmq.send(zmq_publisher, msg)

    {:noreply, zmq_publisher}
  end

  def handle_cast({:send_multipart, msg}, zmq_publisher) do
    Logger.debug "ZmqPublisher: send message #{inspect msg}, socket #{inspect zmq_publisher}"	

    :ok = :erlzmq.send(zmq_publisher, "header", [:sndmore])
    :ok = :erlzmq.send(zmq_publisher, msg)

    {:noreply, zmq_publisher}
  end

	# private API	
	defp parse_conf_file (file) do
		conf_path = Path.join([__DIR__, "../csv_conf_file", file])
		{:ok, content} = File.read(conf_path)
	  Logger.debug("...parse_file, dir #{inspect conf_path}, content #{inspect content}")
		content
	end
	
	
end
