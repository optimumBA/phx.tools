defmodule GitHubWorkflows do
  @moduledoc """
  Used by a custom tool to generate GitHub workflows.
  Reduces repetition.
  """

  def get do
    repo_name = "phx_tools"
    app_name = "phx-tools"

    %{
      "main.yml" => main_workflow(),
      "pr.yml" => pr_workflow(repo_name, app_name),
      "pr_closure.yml" => pr_closure_workflow(repo_name, app_name)
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
        jobs: [
          compile: compile_job(),
          credo: credo_job(),
          deps_audit: deps_audit_job(),
          dialyzer: dialyzer_job(),
          format: format_job(),
          hex_audit: hex_audit_job(),
          prettier: prettier_job(),
          sobelow: sobelow_job(),
          test: test_job(),
          test_linux_script_job: test_linux_script_job(),
          test_macos_script_job: test_macos_script_job(),
          unused_deps: unused_deps_job(),
          deploy_production_app: [
            name: "Deploy production app",
            needs: [
              "compile",
              "credo",
              "deps_audit",
              "dialyzer",
              "format",
              "hex_audit",
              "prettier",
              "sobelow",
              "test",
              "test_linux_script_job",
              "test_macos_script_job",
              "unused_deps"
            ],
            "runs-on": "ubuntu-latest",
            env: [FLY_API_TOKEN: "${{ secrets.FLY_API_TOKEN }}"],
            steps: [
              checkout_step(),
              [
                name: "Deploy",
                uses: "superfly/flyctl-actions@1.3",
                with: [
                  args: "deploy"
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  end

  defp pr_workflow(repo_name, app_name) do
    [
      [
        name: "PR",
        on: [
          pull_request: [
            branches: ["main"],
            types: ["opened", "reopened", "synchronize"]
          ]
        ],
        jobs: [
          compile: compile_job(),
          credo: credo_job(),
          deploy_preview_app: deploy_preview_app_job(repo_name, app_name),
          deps_audit: deps_audit_job(),
          dialyzer: dialyzer_job(),
          format: format_job(),
          hex_audit: hex_audit_job(),
          prettier: prettier_job(),
          sobelow: sobelow_job(),
          test: test_job(),
          test_linux_script_job: test_linux_script_job(),
          test_macos_script_job: test_macos_script_job(),
          unused_deps: unused_deps_job()
        ]
      ]
    ]
  end

  defp pr_closure_workflow(repo_name, app_name) do
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
          delete_preview_app: delete_preview_app_job(repo_name, app_name)
        ]
      ]
    ]
  end

  defp checkout_step do
    [
      name: "Checkout",
      uses: "actions/checkout@v2"
    ]
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

  defp delete_preview_app_job(repo_name, app_name) do
    [
      name: "Delete preview app",
      "runs-on": "ubuntu-latest",
      concurrency: [group: "pr-${{ github.event.number }}"],
      env: [
        FLY_API_TOKEN: "${{ secrets.FLY_API_TOKEN }}",
        REPO_NAME: repo_name
      ],
      steps: [
        [
          uses: "actions/checkout@v2"
        ],
        [
          name: "Delete preview app",
          uses: "optimumBA/fly-preview-apps@main",
          with: [
            name: "pr-${{ github.event.number }}-#{app_name}"
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
            environment: "pr-${{ github.event.number }}-#{app_name}",
            ref: "${{ github.head_ref }}"
          ]
        ]
      ]
    ]
  end

  defp deploy_preview_app_job(repo_name, app_name) do
    [
      name: "Deploy preview app",
      needs: [
        "compile",
        "credo",
        "deps_audit",
        "dialyzer",
        "format",
        "hex_audit",
        "prettier",
        "sobelow",
        "test",
        "test_linux_script_job",
        "test_macos_script_job",
        "unused_deps"
      ],
      permissions: "write-all",
      "runs-on": "ubuntu-latest",
      concurrency: [group: "pr-${{ github.event.number }}"],
      env: [
        FLY_API_TOKEN: "${{ secrets.FLY_API_TOKEN }}",
        FLY_ORG: "optimum-bh",
        FLY_REGION: "fra",
        PHX_HOST: "pr-${{ github.event.number }}-#{app_name}.fly.dev",
        REPO_NAME: repo_name
      ],
      environment: [
        name: "pr-${{ github.event.number }}-#{app_name}",
        url: "https://${{ env.PHX_HOST }}"
      ],
      steps: [
        [
          uses: "actions/checkout@v2"
        ],
        [
          name: "Delete previous deployments",
          uses: "strumwolf/delete-deployment-environment@v2.2.3",
          with: [
            token: "${{ secrets.GITHUB_TOKEN }}",
            environment: "pr-${{ github.event.number }}-#{app_name}",
            ref: "${{ github.head_ref }}",
            onlyRemoveDeployments: true
          ]
        ],
        [
          name: "Deploy preview app",
          uses: "optimumBA/fly-preview-apps@main",
          with: [
            name: "pr-${{ github.event.number }}-#{app_name}",
            secrets:
              "APPSIGNAL_APP_ENV=preview APPSIGNAL_PUSH_API_KEY=${{ secrets.APPSIGNAL_PUSH_API_KEY }} PHX_HOST=${{ env.PHX_HOST }} SECRET_KEY_BASE=${{ secrets.SECRET_KEY_BASE }}"
          ]
        ]
      ]
    ]
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
    elixir_job("Dialyzer",
      needs: :compile,
      steps: [
        [
          # Don't cache PLTs based on mix.lock hash, as Dialyzer can incrementally update even old ones
          # Cache key based on Elixir & Erlang version (also useful when running in matrix)
          name: "Restore PLT cache",
          uses: "actions/cache@v3",
          id: "plt_cache",
          with: [
            key: "${{ runner.os }}-${{ env.elixir-version }}-${{ env.otp-version }}-plt",
            "restore-keys":
              "${{ runner.os }}-${{ env.elixir-version }}-${{ env.otp-version }}-plt",
            path: "priv/plts"
          ]
        ],
        [
          # Create PLTs if no cache was found
          name: "Create PLTs",
          if: "steps.plt_cache.outputs.cache-hit != 'true'",
          env: [MIX_ENV: "test"],
          run: "mix dialyzer --plt"
        ],
        [
          name: "Run dialyzer",
          env: [MIX_ENV: "test"],
          run: "mix dialyzer --format short 2>&1"
        ]
      ]
    )
  end

  defp elixir_job(name, opts) do
    needs = Keyword.get(opts, :needs)
    steps = Keyword.get(opts, :steps, [])

    job = [
      name: name,
      "runs-on": "ubuntu-latest",
      env: [
        "elixir-version": "1.14.2",
        "otp-version": "25.2.1"
      ],
      steps:
        [
          checkout_step(),
          [
            name: "Set up Elixir",
            uses: "erlef/setup-beam@v1",
            with: [
              "elixir-version": "${{ env.elixir-version }}",
              "otp-version": "${{ env.otp-version }}"
            ]
          ],
          [
            uses: "actions/cache@v3",
            with: [
              path: "_build\ndeps",
              key: "${{ runner.os }}-mix-${{ hashFiles('**/mix.lock') }}",
              "restore-keys": "${{ runner.os }}-mix"
            ]
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
            path: "~/.npm",
            key: "${{ runner.os }}-node",
            "restore-keys": "${{ runner.os }}-node"
          ]
        ],
        [
          name: "Install Prettier",
          if: "steps.npm-cache.outputs.cache-hit != 'true'",
          run: "npm i -g prettier"
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
          env: [MIX_ENV: "test"],
          run: "mix test --cover --warnings-as-errors"
        ]
      ]
    )
  end

  defp test_linux_script_job do
    test_shell_script_job(
      "Linux",
      "ubuntu-latest",
      "sudo apt-get update && sudo apt-get install -y expect"
    )
  end

  defp test_macos_script_job do
    test_shell_script_job("macOS", "macos-latest", "brew install expect")
  end

  defp test_shell_script_job(os, runs_on, expect_install_command) do
    [
      name: "Test #{os} script",
      "runs-on": runs_on,
      env: [TZ: "America/New_York"],
      steps: [
        checkout_step(),
        [
          name: "Restore script result cache",
          uses: "actions/cache@v3",
          id: "result_cache",
          with: [
            key:
              "${{ runner.os }}-script-${{ hashFiles('test/scripts/script.exp') }}-${{ hashFiles('priv/static/#{os}.sh') }}",
            path: "priv/static/#{os}.sh"
          ]
        ],
        [
          name: "Install expect tool",
          if: "steps.result_cache.outputs.cache-hit != 'true'",
          run: expect_install_command
        ],
        [
          name: "Test the script",
          if: "steps.result_cache.outputs.cache-hit != 'true'",
          run: "cd test/scripts && expect script.exp #{os}.sh"
        ],
        [
          name: "Generate an app and start the server",
          if: "steps.result_cache.outputs.cache-hit != 'true'",
          run: "/bin/zsh -c 'source ~/.zshrc && make -f test/scripts/Makefile'"
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
end
