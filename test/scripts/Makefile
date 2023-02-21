serve:
	mix archive.install --force hex phx_new 1.7.0-rc.4
	pg_ctl start
	mix phx.new --no-install phx_tools_test
	cd phx_tools_test && mix local.rebar --force && mix setup
	cd phx_tools_test && elixir --erl '-detached' -S mix phx.server
