defmodule ActionMessage do
	use Protobuf, from: Path.expand("../proto/action_message.proto", __DIR__)
end