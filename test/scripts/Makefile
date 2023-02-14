serve:
	USER=${USER:-$(id -u -n)}
	HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
	HOME="${HOME:-$(eval echo ~$USER)}"
	sudo -S chsh -s '/bin/zsh' "${USER}"
	source ~/.zshrc
	mix archive.install --force hex phx_new 1.7.0-rc.0
	pg_ctl start -D
	mix phx.new --no-install phx_tools_test
	cd phx_tools_test && mix setup
	cd phx_tools_test && elixir --erl '-detached' -S mix phx.server
