ExZmqTester
===========

A unittest to create a zmq PUB / SUB module, and communicate with protobuf style message.

# To run the test
```
[~/Projects/ex_erlang/ex_zmq_tester]$ iex -S mix                                                                                                                                    [master][ruby-1.9.3-p0] 
Erlang/OTP 17 [erts-6.1] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]


14:15:28.160 [debug] starting publisher, connect to 'tcp://127.0.0.1:20174'

14:15:28.161 [debug] starting zmq_subscriber, binding to 'tcp://*:20174'
Interactive Elixir (1.1.0-dev) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> ZmqPublisher.start_scan(PUB, "configurations...")
:ok

14:15:42.494 [debug] ZmqPublisher: start_scan socket {1, ""}
iex(2)> 
14:15:42.509 [debug] ...send_action_message_out, %ActionMessage.ActionMsg{config_context: "configurations...", config_type: nil, ip: nil, type: :start_scan}

14:15:42.509 [debug] ZmqSubscriber: handle incoming zmq_msg {:zmq, {1, ""}, <<8, 1, 18, 17, 99, 111, 110, 102, 105, 103, 117, 114, 97, 116, 105, 111, 110, 115, 46, 46, 46>>, []}

14:15:42.509 [debug] ZmqSubscriber: message: [<<8, 1, 18, 17, 99, 111, 110, 102, 105, 103, 117, 114, 97, 116, 105, 111, 110, 115, 46, 46, 46>>]

14:15:42.513 [debug] ZmqSubscriber: decoded msg %ActionMessage.ActionMsg{config_context: "configurations...", config_type: nil, ip: nil, type: :start_scan}

nil
iex(3)> 

```



# To create a project with mix:
```
mix new PROJECT_NAME --module MODULE_NAME

e.g., mix new ex_zmq_tester --module ExZmqTester
```

# To pre-register a module
```
def start_link(args) do
  GenServer.start_link(__MODULE__, [args], [name: MODULE_NAME])
end
```







