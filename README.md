# PhxTools

[phx.tools](https://phx.tools/) is a shell script for platforms **Linux** and **macOS** (sorry, Windows users) that configures the development environment for you in a few easy steps.

Once you finish running the script, you'll be able to start the database server, create a new Phoenix application, and launch the server.

Here are the tools that `phx.tools` will install for you, if not already installed:

_Required_

- Build dependencies
- Homebrew (only on macOS)
- asdf
- Erlang
- Elixir
- Phoenix
- PostgreSQL

## Setup

To start your Phoenix server:

- install Elixir, Erlang and Node using [mise](https://mise.jdx.dev)
  - install mise using either `curl https://mise.run | sh` or `brew install mise`
  - make sure to activate it
  - run `mise install`
- run `mix setup`
- start Phoenix server with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Docs

- execute `mix docs --formatter html --open`

It will open documentation in your browser.

## Running tests

- run `mix coveralls` or `mix coveralls.html`

## Contributing

Make sure to execute `make ci` in order to run all the checks before committing the code.
