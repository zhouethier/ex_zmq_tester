ExZmqTester
===========

A unittest to create a zmq PUB / SUB module, and communicate with protobuf style message.

# To run the test
```
$ iex -S mix                                                                                                                  *[master][ruby-1.9.3-p0] 
Erlang/OTP 17 [erts-6.1] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Compiled lib/ex_zmq_tester.ex
Generated ex_zmq_tester.app

14:36:01.004 [debug] starting publisher, connect to 'tcp://127.0.0.1:20174'
Interactive Elixir (1.1.0-dev) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> ZmqPublisher.start_scan(PUB, "my_config")
:ok

14:37:05.087 [debug] ZmqPublisher: start_scan socket {1, ""}
iex(2)> 
14:37:05.101 [debug] ...send_action_message_out, %ActionMessage.ActionMsg{config_context: "my_config", config_type: nil, ip: nil, type: :start_scan}

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







