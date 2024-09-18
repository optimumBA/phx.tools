SHELL := $(SHELL)
current_shell := $(shell basename $(SHELL))

.ONESHELL:
SHELLFLAGS := -eu -c

serve:
	# initdb -D ~/pgdata -U postgres
	# pg_ctl start -D ~/pgdata
	@echo "Current PATH: $$PATH"
	@which mise
	@mise --version
	mise exec -- mix phx.new --no-install phx_tools_test
	cd phx_tools_test
	mise exec -- mix setup
	mise exec -- elixir --erl '-detached' -S mix phx.server
