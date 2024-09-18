SHELL := $(shell echo $$SHELL)

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

serve:
	rm -f .mise.toml
	rm -f .tool-versions

	# Detect and activate mise
	shell_name=$$(basename $$SHELL); \
	if [ "$$shell_name" = "bash" ] || [ "$$shell_name" = "rbash" ]; then \
		eval "$$(~/.local/bin/mise activate bash)"; \
	elif [ "$$shell_name" = "zsh" ]; then \
		eval "$$(~/.local/bin/mise activate zsh)"; \
	else \
		echo "Unsupported shell: $$shell_name"; \
		exit 1; \
	fi

	echo $$PATH



	# Run your commands with mise activated
	mise exec -- mix phx.new --no-install phx_tools_test
	cd phx_tools_test
	mise exec -- mix setup
	mise exec -- elixir --erl '-detached' -S mix phx.server
