SHELL := $(shell echo $$SHELL)

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

serve:
	MISE_DEBUG=1
	MISE_TRACE=1
	rm -f .mise.toml
	rm -f .tool-versions

	echo "Debug: $$PATH"

	@if [[ "$$SHELL" == *"bash"* ]]; then \
		eval "$$(~/.local/bin/mise activate bash --shims)"; \
		eval "$$(~/.local/bin/mise activate bash)"; \
	elif [[ "$$SHELL" == *"zsh"* ]]; then \
		eval "$$(~/.local/bin/mise activate zsh --shims)"; \
		eval "$$(~/.local/bin/mise activate zsh)"; \
	fi

	echo "Debug: $$PATH"
	mise doctor
	ls ~/.local/share/mise/shims
	mise reshim
	ls ~/.local/share/mise/shims

	# initdb -D ~/pgdata -U postgres
	# pg_ctl start -D ~/pgdata
	mix phx.new --no-install phx_tools_test
	cd phx_tools_test
	mix setup
	elixir --erl '-detached' -S mix phx.server
