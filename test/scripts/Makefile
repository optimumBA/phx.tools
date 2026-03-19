SHELL := $(SHELL)
current_shell := $(shell basename $(SHELL))

.ONESHELL:
.SHELLFLAGS := -eu -c

serve:
	mise exec -- mix phx.new --no-ecto --no-install phx_tools_test
	cd phx_tools_test
	mise exec -- mix setup
	nohup mise exec -- mix phx.server &
