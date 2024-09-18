SHELL := $(shell echo $$SHELL)

.ONESHELL:
.SHELLFLAGS := -eu -c

serve:
	@if [[ "$$SHELL" == *"bash"* ]]; then \
		eval "$$(~/.local/bin/mise hook-env -s bash)"; \
	elif [[ "$$SHELL" == *"zsh"* ]]; then \
		eval "$$(~/.local/bin/mise hook-env -s zsh)"; \
	fi

	initdb -D ~/pgdata -U postgres
	pg_ctl start -D ~/pgdata
	mix phx.new --no-install phx_tools_test
	cd phx_tools_test
	mix setup
	elixir --erl '-detached' -S mix phx.server
