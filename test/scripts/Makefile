SHELL := $(SHELL)
current_shell := $(shell basename $(SHELL))

.ONESHELL:
.SHELLFLAGS := -eu -c

serve:
	export PATH="/opt/homebrew/bin:$$PATH"
	mise exec -- mix phx.new --no-ecto --no-install --no-assets phx_tools_test
	cd phx_tools_test
	mise exec -- mix deps.get
	mise exec -- mix compile
	mise exec -- elixir --erl '-detached' -S mix phx.server
