SHELL := $(shell echo $$SHELL)

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

serve:
	rm -f .mise.toml
	rm -f .tool-versions

	if [[ "$$SHELL" == *"bash"* ]]; then \
		source ~/.bash_profile; \
	elif [[ "$$SHELL" == *"zsh"* ]]; then \
		source ~/.zshrc; \
	fi

	# ~/.local/bin/mise exec -- initdb -D ~/pgdata -U postgres
	# ~/.local/bin/mise exec -- pg_ctl start -D ~/pgdata
	~/.local/bin/mise exec -- mix phx.new --no-install phx_tools_test
	cd phx_tools_test
	~/.local/bin/mise exec -- mix setup
	~/.local/bin/mise exec -- elixir --erl '-detached' -S mix phx.server
