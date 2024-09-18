SHELL := $(shell echo $$SHELL)

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

serve:
	MISE_DEBUG=1
	MISE_TRACE=1
	rm -f .mise.toml
	rm -f .tool-versions

	echo "Debug: $$PATH"

	@ls ~/.local/share/mise/shims
	@mise reshim
	@ls ~/.local/share/mise/shims

	@mise doctor

	echo "Debug: $$PATH"

	PATH="~/.local/share/mise/shims:$$PATH"

	echo "Debug: $$PATH"


	# initdb -D ~/pgdata -U postgres
	# pg_ctl start -D ~/pgdata
	mix phx.new --no-install phx_tools_test
	cd phx_tools_test
	mix setup
	elixir --erl '-detached' -S mix phx.server
