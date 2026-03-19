defmodule GithubWorkflows do
  @moduledoc """
  Run `mix github_workflows.generate` after updating this module.
  See https://hexdocs.pm/github_workflows_generator.
  """

  @shells ["bash", "fish", "zsh"]

  def get do
    %{
      "main.yml" => main_workflow(),
      "pr.yml" => pr_workflow()
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
        jobs: test_scripts_jobs()
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
        jobs: test_scripts_jobs()
      ]
    ]
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
        SHELL: shell,
        TZ: "America/New_York"
      ],
      steps:
        [
          checkout_step(),
          [
            name: "Restore script result cache",
            uses: "actions/cache/restore@v4",
            id: "result_cache",
            with: [
              key:
                "${{ runner.os }}-#{shell}-script-${{ hashFiles('test/scripts/script.exp') }}-${{ hashFiles('public/script.sh') }}",
              path: "public/script.sh"
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
                  ~S<sudo sed -i "" "s/%admin\t\tALL = (ALL) ALL/%admin\t\tALL = (ALL) NOPASSWD: ALL/g" /etc/sudoers>
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
              name: "Test the script",
              if: "steps.result_cache.outputs.cache-hit != 'true'",
              run: "cd test/scripts && expect script.exp",
              shell: "#{shell} -l {0}"
            ],
            [
              name: "Generate an app and start the server",
              if: "steps.result_cache.outputs.cache-hit != 'true'",
              run: generate_app_run(os),
              shell: "#{shell} -l {0}"
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
            ],
            [
              name: "Save script result cache",
              if: "steps.result_cache.outputs.cache-hit != 'true'",
              uses: "actions/cache/save@v4",
              with: [
                key:
                  "${{ runner.os }}-#{shell}-script-${{ hashFiles('test/scripts/script.exp') }}-${{ hashFiles('public/script.sh') }}",
                path: "public/script.sh"
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

  defp generate_app_run("Linux"), do: "make -f test/scripts/Makefile serve"

  defp generate_app_run(_macos) do
    """
    mise exec -- mix phx.new --no-ecto --no-install --no-assets phx_tools_test
    cd phx_tools_test
    mise exec -- mix deps.get
    mise exec -- mix compile
    nohup mise exec -- mix phx.server > /tmp/phx_server.log 2>&1 &
    """
  end

  defp checkout_step do
    [
      name: "Checkout",
      uses: "actions/checkout@v4"
    ]
  end
end
