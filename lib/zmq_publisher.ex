defmodule ZmqPublisher do
  use GenServer
  require Logger
  # alias ZmqInterface.State 

  @default_ip "127.0.0.1"
  @pub_port "20174"

  defmodule State do
    defstruct socket: nil, upstream_uid: ""
  end

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

    <<a::32, b::32, c::32>> = :crypto.rand_bytes(12)
    :random.seed({a, b, c})
		uid = :random.uniform(30000)
		
    Logger.debug "starting publisher, connect to #{inspect pub_addr}, uid #{inspect uid}"
    {:ok,  %State{socket: zmq_publisher, upstream_uid: to_string(uid)}}
  end

	def handle_cast({:start_scan, config_file}, state) do
		Logger.debug "ZmqPublisher: start_scan state #{inspect state}"	
		
		config_content = parse_conf_file(config_file)

		msg = ActionMessage.ActionMsg.new(action_type: :start_scan, configuration_content: config_content, configuration_format: :csv, upstream_uid: state.upstream_uid, upstream_name: "ex_zmq_tester")
		encoded_msg = ActionMessage.ActionMsg.encode(msg)
		Logger.debug "...send_action_message_out, #{inspect msg}"
 		:ok = :erlzmq.send(state.socket, encoded_msg)

    {:noreply, state}
	end

  def handle_cast({:send, msg}, state) do
    Logger.debug "ZmqPublisher: send message #{inspect msg}, state #{inspect state}"	
    :ok = :erlzmq.send(state.socket, msg)

    {:noreply, state}
  end

  def handle_cast({:send_multipart, msg}, state) do
    Logger.debug "ZmqPublisher: send message #{inspect msg}, state #{inspect state}"	

    :ok = :erlzmq.send(state.socket, "header", [:sndmore])
    :ok = :erlzmq.send(state.socket, msg)

    {:noreply, state}
  end

  def terminate(_reason, state) do
		Logger.info "Terminating ZmqPublisher."
	  :erlzmq.close(state.socket)
    :ok
  end

	# private API	
	defp parse_conf_file (file) do
		conf_path = Path.join([__DIR__, "../csv_conf_file", file])
		{:ok, content} = File.read(conf_path)
	  Logger.debug("...parse_file, dir #{inspect conf_path}, content #{inspect content}")
		content
	end
	
	
end
