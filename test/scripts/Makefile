#! /bin/bash

SHELL := /bin/bash

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

serve:
	@echo "Current shell: $$SHELL"
	@echo "Current PATH: $$PATH"
	@echo "Contents of ~/.bash_profile:"
	@cat ~/.bash_profile || echo "File not found"
	@echo "asdf version:"
	asdf --version || echo "asdf command not available"
	@echo "Which asdf:"
	which asdf || echo "asdf not found in PATH"
	@echo "Elixir version:"
	elixir --version || echo "Elixir not installed"
	@echo "Erlang version:"
	erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), "releases", erlang:system_info(otp_release), "OTP_VERSION"])), io:fwrite(Version), halt().' -noshell || echo "Erlang not installed"
	@echo "PostgreSQL version:"
	psql --version || echo "PostgreSQL not installed"
	initdb -D ~/pgdata -U postgres
	pg_ctl start -D ~/pgdata
	mix phx.new --no-install phx_tools_test
	cd phx_tools_test && mix local.rebar --force && mix setup
	cd phx_tools_test && elixir --erl '-detached' -S mix phx.server
