SHELL := $(shell echo $$SHELL)

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

serve:
	rm -f .mise.toml
	rm -f .tool-versions

	# Detect and activate mise
	if [ "$(basename $$SHELL)" = "bash" ] || [ "$(basename $$SHELL)" = "rbash" ]; then \
		eval "$$(~/.local/bin/mise activate bash)"; \
	elif [ "$(basename $$SHELL)" = "zsh" ]; then \
		eval "$$(~/.local/bin/mise activate zsh)"; \
	else \
		echo "Unsupported shell: $$(basename $$SHELL)"; \
		exit 1; \
	fi

	# Run your commands with mise activated
	mise exec -- mix phx.new --no-install phx_tools_test
	cd phx_tools_test
	mise exec -- mix setup
	mise exec -- elixir --erl '-detached' -S mix phx.server
