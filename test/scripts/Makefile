SHELL := $(SHELL)
current_shell := $(shell basename $(SHELL))

.ONESHELL:
.SHELLFLAGS := -eu -c

serve:
	@echo "SHELL is $(SHELL)"
	@echo "Current shell is $(current_shell)"
	@echo "Activating mise..."
	@eval "$$($(HOME)/.local/bin/mise activate $(current_shell))" && \
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
