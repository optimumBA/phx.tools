# phx.tools

[phx.tools](https://phx.tools/) is a shell script for **Linux** and **macOS** that configures the Elixir/Phoenix development environment in a few easy steps.

When someone runs `curl https://phx.tools | bash`, Cloudflare Pages middleware serves `script.sh` instead of the landing page. An explicit `Accept: text/markdown` requests the page representation; ordinary installer requests keep receiving the script.

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

## Agent-readable pages

The build derives Markdown pages and `llms.txt` from the authored HTML; About, Contact and Privacy pages describe the tool and current site configuration. Cloudflare Pages serves the installer to ordinary `curl` requests and returns the page representation for an explicit `Accept: text/markdown` request. Build generation uses Python 3.

## Information pages and local review

The homepage and information pages share `src/components/Logo.astro` and `Footer.astro`. The information layout in `src/layouts/Information.astro` loads the same stylesheet and local fonts as the homepage. Edit visitor-facing copy in `src/pages/`; the build regenerates its Markdown representations.

After `npm run build`, run `npm run preview -- --host 127.0.0.1 --port 4313` and review the homepage, About, Contact and Privacy at desktop and phone widths, including their footers. Keep installer and middleware behavior separate from presentation changes; never execute the installer as a website preview check.
