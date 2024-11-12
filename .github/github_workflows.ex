defmodule GithubWorkflows do
  @moduledoc """
  Run `mix github_workflows.generate` after updating this module.
  See https://hexdocs.pm/github_workflows_generator.
  """

  @app_name_prefix "phx-tools"
  @environment_name "pr-${{ github.event.number }}"
  @preview_app_name "#{@app_name_prefix}-#{@environment_name}"
  @preview_app_host "#{@preview_app_name}.fly.dev"
  @repo_name "phx_tools"
  @shells ["bash", "zsh"]

  def get do
    %{
      "main.yml" => main_workflow(),
      "pr.yml" => pr_workflow(),
      "pr_closure.yml" => pr_closure_workflow()
    }
  end

  defp main_workflow do
    [
      [
        name: "Main",
        on: [
          push: [
            branches: ["main"]
          ]
        ],
        jobs:
          ci_jobs() ++
            [
              deploy_production_app: deploy_production_app_job()
            ]
      ]
    ]
  end

  defp pr_workflow do
    [
      [
        name: "PR",
        on: [
          pull_request: [
            branches: ["main"],
            types: ["opened", "reopened", "synchronize"]
          ]
        ],
        jobs:
          ci_jobs() ++
            [
              deploy_preview_app: deploy_preview_app_job()
            ]
      ]
    ]
  end

  defp pr_closure_workflow do
    [
      [
        name: "PR closure",
        on: [
          pull_request: [
            branches: ["main"],
            types: ["closed"]
          ]
        ],
        jobs: [
          delete_preview_app: delete_preview_app_job()
        ]
      ]
    ]
  end

  defp ci_jobs do
    [
      compile: compile_job(),
      credo: credo_job(),
      deps_audit: deps_audit_job(),
      dialyzer: dialyzer_job(),
      format: format_job(),
      hex_audit: hex_audit_job(),
      prettier: prettier_job(),
      sobelow: sobelow_job(),
      test: test_job(),
      unused_deps: unused_deps_job()
    ] ++ test_scripts_jobs()
  end

  defp compile_job do
    elixir_job("Install deps and compile",
      steps: [
        [
          name: "Install Elixir dependencies",
          env: [MIX_ENV: "test"],
          run: "mix deps.get"
        ],
        [
          name: "Compile",
          env: [MIX_ENV: "test"],
          run: "mix compile"
        ]
      ]
    )
  end

  defp credo_job do
    elixir_job("Credo",
      needs: :compile,
      steps: [
        [
          name: "Check code style",
          env: [MIX_ENV: "test"],
          run: "mix credo --strict"
        ]
      ]
    )
  end

  defp delete_preview_app_job do
    [
      name: "Delete preview app",
      "runs-on": "ubuntu-latest",
      concurrency: [group: "pr-${{ github.event.number }}"],
      steps: [
        checkout_step(),
        [
          name: "Delete preview app",
          uses: "optimumBA/fly-preview-apps@main",
          env: [
            FLY_API_TOKEN: "${{ secrets.FLY_API_TOKEN }}",
            REPO_NAME: @repo_name
          ],
          with: [
            name: @preview_app_name
          ]
        ],
        [
          name: "Generate token",
          uses: "navikt/github-app-token-generator@v1.1.1",
          id: "generate_token",
          with: [
            "app-id": "${{ secrets.GH_APP_ID }}",
            "private-key": "${{ secrets.GH_APP_PRIVATE_KEY }}"
          ]
        ],
        [
          name: "Delete GitHub environment",
          uses: "strumwolf/delete-deployment-environment@v2.2.3",
          with: [
            token: "${{ steps.generate_token.outputs.token  }}",
            environment: @environment_name,
            ref: "${{ github.head_ref }}"
          ]
        ]
      ]
    ]
  end

  defp deploy_job(env, opts) do
    [
      name: "Deploy #{env} app",
      needs: Enum.map(ci_jobs(), &elem(&1, 0)),
      "runs-on": "ubuntu-latest"
    ] ++ opts
  end

  defp deploy_preview_app_job do
    deploy_job("preview",
      permissions: "write-all",
      concurrency: [group: @environment_name],
      environment: preview_app_environment(),
      steps: [
        checkout_step(),
        delete_previous_deployments_step(),
        [
          name: "Deploy preview app",
          uses: "optimumBA/fly-preview-apps@main",
          env: fly_env(),
          with: [
            name: @preview_app_name,
            secrets:
              "APPSIGNAL_APP_ENV=preview APPSIGNAL_PUSH_API_KEY=${{ secrets.APPSIGNAL_PUSH_API_KEY }} PHX_HOST=${{ env.PHX_HOST }} SECRET_KEY_BASE=${{ secrets.SECRET_KEY_BASE }}"
          ]
        ]
      ]
    )
  end

  defp deploy_production_app_job do
    deploy_job("production",
      steps: [
        checkout_step(),
        [
          uses: "superfly/flyctl-actions/setup-flyctl@master"
        ],
        [
          run: "flyctl deploy --remote-only",
          env: [
            FLY_API_TOKEN: "${{ secrets.FLY_API_TOKEN }}"
          ]
        ]
      ]
    )
  end

  defp deps_audit_job do
    elixir_job("Deps audit",
      needs: :compile,
      steps: [
        [
          name: "Check for vulnerable Mix dependencies",
          env: [MIX_ENV: "test"],
          run: "mix deps.audit"
        ]
      ]
    )
  end

  defp dialyzer_job do
    cache_key_prefix =
      "${{ runner.os }}-${{ steps.setup-beam.outputs.elixir-version }}-${{ steps.setup-beam.outputs.otp-version }}-plt"

    elixir_job("Dialyzer",
      needs: :compile,
      steps: [
        [
          name: "Restore PLT cache",
          uses: "actions/cache@v3",
          with:
            [
              path: "priv/plts"
            ] ++ cache_opts(cache_key_prefix)
        ],
        [
          name: "Create PLTs",
          env: [MIX_ENV: "test"],
          run: "mix dialyzer --plt"
        ],
        [
          name: "Run dialyzer",
          env: [MIX_ENV: "test"],
          run: "mix dialyzer"
        ]
      ]
    )
  end

  defp elixir_job(name, opts) do
    needs = Keyword.get(opts, :needs)
    steps = Keyword.get(opts, :steps, [])

    cache_key_prefix =
      "${{ runner.os }}-${{ steps.setup-beam.outputs.elixir-version }}-${{ steps.setup-beam.outputs.otp-version }}-mix"

    job = [
      name: name,
      "runs-on": "ubuntu-latest",
      steps:
        [
          checkout_step(),
          [
            id: "setup-beam",
            name: "Set up Elixir",
            uses: "erlef/setup-beam@v1",
            with: [
              "version-file": ".tool-versions",
              "version-type": "strict"
            ]
          ],
          [
            uses: "actions/cache@v3",
            with:
              [
                path: ~S"""
                _build
                deps
                """
              ] ++ cache_opts(cache_key_prefix)
          ]
        ] ++ steps
    ]

    if needs do
      Keyword.put(job, :needs, needs)
    else
      job
    end
  end

  defp format_job do
    elixir_job("Format",
      needs: :compile,
      steps: [
        [
          name: "Check Elixir formatting",
          env: [MIX_ENV: "test"],
          run: "mix format --check-formatted"
        ]
      ]
    )
  end

  defp hex_audit_job do
    elixir_job("Hex audit",
      needs: :compile,
      steps: [
        [
          name: "Check for retired Hex packages",
          env: [MIX_ENV: "test"],
          run: "mix hex.audit"
        ]
      ]
    )
  end

  defp prettier_job do
    [
      name: "Check formatting using Prettier",
      "runs-on": "ubuntu-latest",
      steps: [
        checkout_step(),
        [
          name: "Restore npm cache",
          uses: "actions/cache@v3",
          id: "npm-cache",
          with: [
            path: "node_modules",
            key: "${{ runner.os }}-prettier"
          ]
        ],
        [
          name: "Install Prettier",
          if: "steps.npm-cache.outputs.cache-hit != 'true'",
          run: "npm i -D prettier prettier-plugin-toml"
        ],
        [
          name: "Run Prettier",
          run: "npx prettier -c ."
        ]
      ]
    ]
  end

  defp sobelow_job do
    elixir_job("Security check",
      needs: :compile,
      steps: [
        [
          name: "Check for security issues using sobelow",
          env: [MIX_ENV: "test"],
          run: "mix sobelow --config .sobelow-conf"
        ]
      ]
    )
  end

  defp test_job do
    elixir_job("Test",
      needs: :compile,
      steps: [
        [
          name: "Run tests",
          env: [
            MIX_ENV: "test"
          ],
          run: "mix test --cover --warnings-as-errors"
        ]
      ]
    )
  end

  defp test_scripts_jobs do
    Enum.reduce(@shells, [], fn shell, jobs ->
      jobs ++
        [
          {:"test_linux_#{shell}", test_linux_script_job(shell)},
          {:"test_macos_#{shell}", test_macos_script_job(shell)}
        ]
    end)
  end

  defp test_shell_script_job(opts) do
    os = Keyword.fetch!(opts, :os)
    runs_on = Keyword.fetch!(opts, :runs_on)
    shell = Keyword.fetch!(opts, :shell)
    shell_install_command = Keyword.fetch!(opts, :shell_install_command)
    expect_install_command = Keyword.fetch!(opts, :expect_install_command)

    [
      name: "Test #{os} script with #{shell} shell",
      "runs-on": runs_on,
      env: [
        SHELL: "/bin/#{shell}",
        TZ: "America/New_York"
      ],
      steps:
        [
          checkout_step(),
          [
            name: "Restore script result cache",
            uses: "actions/cache@v3",
            id: "result_cache",
            with: [
              key:
                "${{ runner.os }}-#{shell}-script-${{ hashFiles('test/scripts/script.exp') }}-${{ hashFiles('priv/script.sh') }}",
              path: "priv/static/#{os}.sh"
            ]
          ]
        ] ++
          if(shell == "bash",
            do: [],
            else: [
              [
                name: "Install shell",
                if: "steps.result_cache.outputs.cache-hit != 'true'",
                run: shell_install_command
              ]
            ]
          ) ++
          if(os == "Linux",
            do: [],
            else: [
              [
                name: "Disable password prompt for macOS",
                if: "steps.result_cache.outputs.cache-hit != 'true'",
                run:
                  ~S<sudo sed -i "" "s/%admin		ALL = (ALL) ALL/%admin		ALL = (ALL) NOPASSWD: ALL/g" /etc/sudoers>
              ]
            ]
          ) ++
          [
            [
              name: "Install expect tool",
              if: "steps.result_cache.outputs.cache-hit != 'true'",
              run: expect_install_command
            ],
            [
              name: "Remove mise config files",
              run: "rm -f .mise.toml .tool-versions"
            ],
            [
              name: "Test the script",
              if: "steps.result_cache.outputs.cache-hit != 'true'",
              run: "cd test/scripts && expect script.exp #{os}.sh",
              shell: "/bin/#{shell} -l {0}"
            ],
            [
              name: "Generate an app and start the server",
              if: "steps.result_cache.outputs.cache-hit != 'true'",
              run: "make -f test/scripts/Makefile serve",
              shell: "/bin/#{shell} -l {0}"
            ],
            [
              name: "Check HTTP status code",
              if: "steps.result_cache.outputs.cache-hit != 'true'",
              uses: "nick-fields/retry@v2",
              with: [
                command:
                  "INPUT_SITES='[\"http://localhost:4000\"]' INPUT_EXPECTED='[200]' ./test/scripts/check_status_code.sh",
                max_attempts: 7,
                retry_wait_seconds: 5,
                timeout_seconds: 1
              ]
            ]
          ]
    ]
  end

  defp test_linux_script_job(shell) do
    test_shell_script_job(
      expect_install_command: "sudo apt-get update && sudo apt-get install -y expect",
      os: "Linux",
      runs_on: "ubuntu-latest",
      shell: shell,
      shell_install_command: "sudo apt-get update && sudo apt-get install -y #{shell}"
    )
  end

  defp test_macos_script_job(shell) do
    test_shell_script_job(
      expect_install_command: "brew install expect",
      os: "macOS",
      runs_on: "macos-latest",
      shell: shell,
      shell_install_command: "brew install #{shell}"
    )
  end

  defp unused_deps_job do
    elixir_job("Check unused deps",
      needs: :compile,
      steps: [
        [
          name: "Check for unused Mix dependencies",
          env: [MIX_ENV: "test"],
          run: "mix deps.unlock --check-unused"
        ]
      ]
    )
  end

  defp checkout_step do
    [
      name: "Checkout",
      uses: "actions/checkout@v4"
    ]
  end

  defp delete_previous_deployments_step do
    [
      name: "Delete previous deployments",
      uses: "strumwolf/delete-deployment-environment@v2.2.3",
      with: [
        token: "${{ secrets.GITHUB_TOKEN }}",
        environment: @environment_name,
        ref: "${{ github.head_ref }}",
        onlyRemoveDeployments: true
      ]
    ]
  end

  defp cache_opts(prefix) do
    [
      key: "#{prefix}-${{ github.sha }}",
      "restore-keys": ~s"""
      #{prefix}-
      """
    ]
  end

  defp fly_env do
    [
      FLY_API_TOKEN: "${{ secrets.FLY_API_TOKEN }}",
      FLY_ORG: "optimum-bh",
      FLY_REGION: "fra",
      PHX_HOST: "#{@preview_app_name}.fly.dev",
      REPO_NAME: @repo_name
    ]
  end

  defp preview_app_environment do
    [
      name: @environment_name,
      url: "https://#{@preview_app_host}"
    ]
  end
end
