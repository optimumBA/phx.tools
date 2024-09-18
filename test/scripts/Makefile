SHELL := $(shell echo $$SHELL)

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

serve:
	MISE_DEBUG=1
	MISE_TRACE=1
	rm -f .mise.toml
	rm -f .tool-versions

	echo "Debug: $$PATH"

	export PATH="$$HOME/.local/share/mise/shims:$$PATH"

	echo "Debug: $$PATH"

	mise reshim

	echo "Debug: $$PATH"
	mise doctor

	# mise exec -- initdb -D ~/pgdata -U postgres
	# mise exec -v -- pg_ctl start -D ~/pgdata
	mise exec -- mix phx.new --no-install phx_tools_test
	mix phx.new --no-install phx_tools_test_2
	cd phx_tools_test
	mise exec -- mix setup
	mise exec -- elixir --erl '-detached' -S mix phx.server
