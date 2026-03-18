.ONESHELL:
.SHELLFLAGS := -eu -c

serve:
	mise exec -- mix phx.new --no-ecto --no-install --no-assets phx_tools_test
	cd phx_tools_test
	mise exec -- mix deps.get
	mise exec -- mix compile
	nohup mise exec -- mix phx.server > /tmp/phx_server.log 2>&1 &
