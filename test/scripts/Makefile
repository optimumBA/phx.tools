serve:
	. ~/.bashrc
	mise use erlang@27.0.1
	mise use elixir@1.17.2-otp-27
	mix phx.new --no-install phx_tools_test
	cd phx_tools_test && mix local.rebar --force && mix setup
	cd phx_tools_test && elixir --erl '-detached' -S mix phx.server
