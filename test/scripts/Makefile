SHELL := $(SHELL)
current_shell := $(shell basename $(SHELL))

.ONESHELL:
SHELLFLAGS := -eu -c

serve:
	mise exec -- mix phx.new --no-ecto --no-install phx_tools_test
	cd phx_tools_test
	mise exec -- mix setup
	mise exec -- elixir --erl '-detached' -S mix phx.server
