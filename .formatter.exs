[
  import_deps: [:phoenix],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: [
    "*.{heex,ex,exs}",
    ".github/github_workflows.ex",
    "{config,lib,test}/**/*.{heex,ex,exs}"
  ]
]
