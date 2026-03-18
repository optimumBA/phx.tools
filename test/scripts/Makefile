SHELL := $(SHELL)
current_shell := $(shell basename $(SHELL))

.ONESHELL:

ifeq ($(current_shell),fish)
.SHELLFLAGS := -c
else
.SHELLFLAGS := -eu -c
endif

serve:
	mise exec -- mix phx.new --no-ecto --no-install --no-assets phx_tools_test
	cd phx_tools_test
	mise exec -- mix deps.get
	mise exec -- mix compile
	nohup mise exec -- mix phx.server &
