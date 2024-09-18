SHELL := $(shell echo $$SHELL)

.ONESHELL:
.SHELLFLAGS := -eu -c

serve:
	mise exec initdb -D ~/pgdata -U postgres
	mise exec pg_ctl start -D ~/pgdata
	mise exec mix phx.new --no-install phx_tools_test
	cd phx_tools_test
	mise exec mix setup
	mise exec elixir --erl '-detached' -S mix phx.server
