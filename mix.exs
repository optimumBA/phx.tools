defmodule PhxTools.MixProject do
  use Mix.Project

  def project do
    [
      app: :phx_tools,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: phoenix_deps() ++ optimum_deps() ++ app_deps(),

      # CI
      dialyzer: [
        plt_add_apps: [:ex_unit, :mix],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      preferred_cli_env: [
        ci: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        credo: :test,
        dialyzer: :test,
        sobelow: :test
      ],
      test_coverage: [tool: ExCoveralls],

      # Docs
      name: "PhxTools",
      source_url: "https://github.com/optimumBA/phx.tools",
      docs: [
        extras: ["README.md"],
        main: "readme",
        source_ref: "main"
      ],

      # Release
      releases: [
        phx_tools: [
          include_executables_for: [:unix]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PhxTools.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp app_deps do
    [
      {:ua_parser, "~> 1.8"}
    ]
  end

  defp optimum_deps do
    [
      {:appsignal_phoenix, "~> 2.3"},
      {:credo, "~> 1.7", only: :test, runtime: false},
      {:dialyxir, "~> 1.4", only: :test, runtime: false},
      {:doctest_formatter, "~> 0.3", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:faker, "~> 0.18", only: :test},
      {:github_workflows_generator, "~> 0.1", only: :dev, runtime: false},
      {:mix_audit, "~> 2.1", only: :test, runtime: false},
      {:sobelow, "~> 0.13", only: :test, runtime: false}
    ]
  end

  defp phoenix_deps do
    [
      {:phoenix, "~> 1.7.0-rc.0", override: true},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.18.3"},
      {:heroicons, "~> 0.5"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.7.2"},
      {:esbuild, "~> 0.5", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.1.8", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: [
        "deps.get",
        "cmd npm i -D prettier prettier-plugin-toml",
        "assets.setup",
        "assets.build"
      ],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind phx_tools", "esbuild phx_tools"],
      "assets.deploy": [
        "tailwind phx_tools --minify",
        "esbuild phx_tools --minify",
        "phx.digest"
      ],
      ci: [
        "deps.unlock --check-unused",
        "deps.audit",
        "hex.audit",
        "sobelow --config .sobelow-conf",
        "format --check-formatted",
        "cmd npx prettier -c .",
        "credo --strict",
        "dialyzer",
        "test --cover --warnings-as-errors"
      ],
      prettier: ["cmd npx prettier -w ."]
    ]
  end
end
