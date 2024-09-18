SHELL := /bin/bash

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

serve:
	@echo "Activating mise..."
	@eval "$$($(HOME)/.local/bin/mise activate bash)" && \
	echo "Mise activated." && \
	echo "Current PATH: $$PATH" && \
	mise which mix && \
	mise --version && \
	mise plugin list && \
	which mix || echo "mix not found in PATH" && \
	mix --version || echo "Unable to execute mix" && \
	mise doctor && \
	mix phx.new demo_app && \
	cd demo_app && \
	mix phx.server
