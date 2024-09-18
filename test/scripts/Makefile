SHELL := $(shell echo $$SHELL)

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

serve:
	rm -f .mise.toml
	rm -f .tool-versions

	@if [[ "$$SHELL" == *"bash"* ]]; then \
		echo "bash"
		eval "$$(~/.local/bin/mise activate bash)"; \
		eval "$$(~/.local/bin/mise hook-env -s bash)"; \
	elif [[ "$$SHELL" == *"zsh"* ]]; then \
		echo "zsh"
		eval "$$(~/.local/bin/mise activate zsh)"; \
		eval "$$(~/.local/bin/mise hook-env -s zsh)"; \
	fi

	# initdb -D ~/pgdata -U postgres
	# pg_ctl start -D ~/pgdata
	mix phx.new --no-install phx_tools_test
	cd phx_tools_test
	mix setup
	elixir --erl '-detached' -S mix phx.server
