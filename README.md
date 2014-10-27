ExZmqTester
===========

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







