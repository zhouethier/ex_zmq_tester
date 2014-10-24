require Logger

defmodule ZmqSubscriber do
	use GenServer
	alias ZmqInterface.State
	
	@ip "10.1.3.109"
	@sub_port "31285"
	
	# public API
	def start_link do
		GenServer.start_link(__MODULE__, [], [])
	end
	
	# GenServer Interface
	def init(_arg) do
		{:ok, context} = :erlzmq.context()
		{:ok, zmq_subscriber} = :erlzmq.socket(context, [:sub])
		sub_addr = 'tcp://#{@ip}:#{@sub_port}'
		:erlzmq.bind(zmq_subscriber, sub_addr)
		:erlzmq.setsockopt(zmq_subscriber, :subscribe, <<>>)
		
		loop(zmq_subscriber)
		
		Logger.debug "starting zmq_subscriber, binding to #{inspect sub_addr}"
		{:ok, %State{subscriber: zmq_subscriber}}
	end
	
	def handle_info({:zmq_msg, data}, state) do
		Logger.debug "ZmqSubscriber: handle incoming zmq_msg #{inspect data}"
		{:noreply, state}
	end
	
	def handle_info(msg, state) do
		Logger.debug "ZmqSubscriber: handle incoming msg #{inspect msg}"
		{:noreply, state}
	end
	
	# private API
	defp loop(sub) do
		{ok, data} = :erlzmq.recv(sub)
		Logger.debug "ZmqSubscriber, recv data #{inspect data}"
		
		loop(sub)
	end
end