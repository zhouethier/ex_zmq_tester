require Logger

defmodule ZmqPublisher do
	use GenServer
	alias ZmqInterface.State 
	
	@ip "10.1.3.109"
	@pub_port "31285"
	
	# public API
	def start_link do
		GenServer.start_link(__MODULE__, [], [])
	end
	
	def send(pid, msg) do
		GenServer.cast(pid, {:send, msg})
	end
	
	# GenServer Interface
	def init(_arg) do
		{:ok, context} = :erlzmq.context()
		{:ok, zmq_publisher} = :erlzmq.socket(context, [:pub])
		pub_addr = 'tcp://#{@ip}:#{@pub_port}'
	  :erlzmq.connect(zmq_publisher, pub_addr)	
	
		Logger.debug "starting publisher, connect to #{inspect pub_addr}"
		{:ok, %State{publisher: zmq_publisher}}		
	end
	
	def handle_cast({:send, msg}, state=%State{publisher: zmq_publisher}) do
		Logger.debug "ZmqPublisher: handle send... message #{inspect msg}, state #{inspect state}"		
	  :erlzmq.send(zmq_publisher, msg)	
		
		notify(msg)
		
		{:noreply, state}
	end
	
	defp notify(msg) do
		Logger.debug "ZmqPublisher: notify #{inspect msg}"
		{:ok, {:zmq_msg, msg}}
	end
	
end