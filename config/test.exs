import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phx_tools, PhxToolsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "gZrzk0Q0m8EygWkJJk7IUTx6vK9MsyOJa6bK03AmQNWs7z2Pnw5H56q8w36m0Xzi",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
