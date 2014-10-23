require Logger

defmodule ZmqSubscriber do
	use GenServer
	alias ZmqInterface.State
	
	@ip "127.0.0.1"
	@sub_port "20174"
	
	# public API
	def start_link do
		GenServer.start_link(__MODULE__, [], [])
	end
	
	# GenServer Interface
	def init(_arg) do
		{:ok, context} = :erlzmq.context()
		{:ok, zmq_subscriber} = :erlzmq.socket(context, [:sub])
		sub_addr = 'tcp://*:#{@sub_port}'
		:erlzmq.bind(zmq_subscriber, sub_addr)
		:erlzmq.setsockopt(zmq_subscriber, :subscribe, <<>>)
		
		Logger.debug "starting zmq_subscriber, binding to #{inspect sub_addr}"
		{:ok, %State{subscriber: zmq_subscriber}}
	end
	
	def handle_info(msg, state) do
		Logger.debug "ZmqSubscriber: handle incoming msg #{inspect msg}"
		{:noreply, state}
	end
end