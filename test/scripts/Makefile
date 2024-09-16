serve:
	@echo "Current PATH: $$PATH"
	@echo "Contents of .bashrc:"
	@cat $(HOME)/.bashrc
	@echo "Checking asdf installation:"
	which asdf || echo "asdf not found in PATH"
	@echo "Sourcing .bashrc..."
	. ~/.bashrc
	@echo "PATH after sourcing .bashrc: $$PATH"
	which asdf || echo "asdf still not found in PATH"
	asdf --version || echo "asdf command not available"
	@echo "ASDF_DIR: $$ASDF_DIR"
	initdb -D ~/pgdata -U postgres
	pg_ctl start -D ~/pgdata
	mix phx.new --no-install phx_tools_test
	cd phx_tools_test && mix local.rebar --force && mix setup
	cd phx_tools_test && elixir --erl '-detached' -S mix phx.server
