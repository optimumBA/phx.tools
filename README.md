# PhxTools

[phx.tools](https://phx.tools/) is a shell script for platforms **Linux** and **macOS** (sorry, Windows users) that configures the development environment for you in a few easy steps.

Once you finish running the script, you'll be able to start the database server, create a new Phoenix application, and launch the server.

Here are the tools that `phx.tools` will install for you, if not already installed:

_Required_

- Build dependencies
- Zsh
- Homebrew
- asdf
- Erlang
- Elixir
- Phoenix
- PostgreSQL

_Optional_

- Chrome
- Node.js
- ChromeDriver
- Docker

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
