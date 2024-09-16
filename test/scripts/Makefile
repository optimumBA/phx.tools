serve:
	. ~/.bashrc
	which asdf
	asdf list
	# . ~/.bashrc
	echo $(HOME)
	initdb -D ~/pgdata -U postgres
	pg_ctl start -D ~/pgdata
	mix phx.new --no-install phx_tools_test
	cd phx_tools_test && mix local.rebar --force && mix setup
	cd phx_tools_test && elixir --erl '-detached' -S mix phx.server
