SHELL := $(shell echo $$SHELL)

.ONESHELL:
.SHELLFLAGS := -eu -c

serve:
	rm -f .mise.toml
	rm -f .tool-versions

	echo "Debug: $$PATH"
	mise doctor

	@if [[ "$$SHELL" == *"bash"* ]]; then \
		eval "$$(~/.local/bin/mise activate bash)"; \
		eval "$$(~/.local/bin/mise hook-env -s bash)"; \
	elif [[ "$$SHELL" == *"zsh"* ]]; then \
		eval "$$(~/.local/bin/mise activate zsh)"; \
		eval "$$(~/.local/bin/mise hook-env -s zsh)"; \
	fi

	echo "Debug: $$PATH"
	mise doctor

	# mise exec -- initdb -D ~/pgdata -U postgres
	# mise exec -v -- pg_ctl start -D ~/pgdata
	mise exec -- mix phx.new --no-install phx_tools_test
	mix phx.new --no-install phx_tools_test_2
	cd phx_tools_test
	mise exec -- mix setup
	mise exec -- elixir --erl '-detached' -S mix phx.server
