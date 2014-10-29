ExZmqTester
===========

A unittest to create a zmq PUB / SUB module, and communicate with protobuf style message.

# To run the test
```
$ iex -S mix
iex(1)> {ok, pub} = ZmqPublisher.start_link
iex(2)> ZmqSubscriber.start_link
iex(3)> ZmqPublisher.start_scan(pub) 

Expected to see:

iex(1)> {ok, pub} = ZmqPublisher.start_link

10:48:40.027 [debug] starting publisher, connect to 'tcp://127.0.0.1:20174'
{:ok, #PID<0.132.0>}
iex(2)> ZmqSubscriber.start_link

10:48:48.996 [debug] starting zmq_subscriber, binding to 'tcp://*:20174'
{:ok, #PID<0.135.0>}
iex(3)> ZmqPublisher.start_scan(pub) 
:ok

10:48:57.037 [debug] ZmqPublisher: start_scan socket {1, ""}
iex(4)> 
10:48:57.054 [debug] ...send_action_message_out, %ActionMessage.ActionMsg{config_context: nil, config_type: nil, ip: nil, type: :start_scan}

10:48:57.054 [debug] ZmqSubscriber: handle incoming zmq_msg {:zmq, {1, ""}, <<8, 1>>, []}

10:48:57.054 [debug] ZmqSubscriber: message: [<<8, 1>>]

10:48:57.061 [debug] ZmqSubscriber: decoded msg %ActionMessage.ActionMsg{config_context: nil, config_type: nil, ip: nil, type: :start_scan}

nil

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







