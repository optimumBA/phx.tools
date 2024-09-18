SHELL := $(shell echo $$SHELL)

.ONESHELL:
.SHELLFLAGS := -eu -c

serve:
	eval "$(~/.local/bin/mise hook-env)"
	initdb -D ~/pgdata -U postgres
	pg_ctl start -D ~/pgdata
	mix phx.new --no-install phx_tools_test
	cd phx_tools_test
	mix setup
	elixir --erl '-detached' -S mix phx.server
