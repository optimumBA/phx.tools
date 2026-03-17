# phx.tools

[phx.tools](https://phx.tools/) is a shell script for **Linux** and **macOS** that configures the Elixir/Phoenix development environment in a few easy steps.

## Development

Open `public/index.html` in a browser, or serve it with any HTTP server:

```bash
python3 -m http.server --directory public
```

## Updating GitHub workflows

Edit `.github/github_workflows.ex`, then regenerate:

```bash
github_workflows_generator
```

Install once via `mix escript.install hex github_workflows_generator`.
