require Logger

defmodule ZmqPublisher do
	use GenServer
	alias ZmqInterface.State 
	
	@ip "127.0.0.1"
	@pub_port "20174"
	@sub_port "20174"
	
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
		{:noreply, state}
	end
	
end