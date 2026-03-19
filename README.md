# phx.tools

[phx.tools](https://phx.tools/) is a shell script for **Linux** and **macOS** that configures the Elixir/Phoenix development environment in a few easy steps.

When someone runs `curl https://phx.tools | bash`, Caddy serves `script.sh` instead of the landing page.

## Development

Install dependencies:

```bash
npm install
```

Build the site:

```bash
npm run build
```

Watch for changes and serve locally:

```bash
npm run serve
```

## Updating GitHub workflows

Edit `.github/github_workflows.ex`, then regenerate:

```bash
github_workflows_generator
```

Install once via `mix escript.install hex github_workflows_generator`.
