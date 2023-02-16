serve:
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	asdf reshim
	mix archive.install --force hex phx_new 1.7.0-rc.0
	pg_ctl start
	mix phx.new --install phx_tools_test
	cd phx_tools_test && mix setup
	cd phx_tools_test && elixir --erl '-detached' -S mix phx.server
