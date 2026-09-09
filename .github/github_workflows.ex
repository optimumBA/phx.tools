defmodule GithubWorkflows do
  @moduledoc """
  Run `mix github_workflows.generate` after updating this module.
  See https://hexdocs.pm/github_workflows_generator.
  """

  @shells ["bash", "fish", "zsh"]

  def get do
    %{
      "main.yml" => [
        [
          name: "Main",
          on: [push: [branches: ["main"]], workflow_dispatch: nil],
          permissions: [contents: "read"],
          concurrency: [
            group: "${{ github.workflow }}-${{ github.ref }}",
            "cancel-in-progress": true
          ],
          jobs: jobs()
        ]
      ],
      "pr.yml" => [
        [
          name: "PR",
          on: [pull_request: [branches: ["main"], types: ["opened", "reopened", "synchronize"]]],
          permissions: [contents: "read"],
          concurrency: [
            group: "${{ github.workflow }}-${{ github.ref }}",
            "cancel-in-progress": true
          ],
          jobs: jobs()
        ]
      ]
    }
  end

  defp jobs do
    [
      build_site: [
        name: "Build and test site",
        "runs-on": "ubuntu-latest",
        "timeout-minutes": 10,
        steps: [
          [uses: "actions/checkout@v4"],
          [
            uses: "actions/setup-node@v4",
            with: ["node-version-file": ".node-version", cache: "npm"]
          ],
          [run: "npm ci"],
          [run: "npm run build"],
          [run: "node --test test/site/*.test.js"],
          [run: "sudo apt-get update && sudo apt-get install -y expect"],
          [run: "python3 test/scripts/test_harness.py"]
        ]
      ]
    ] ++
      Enum.flat_map(@shells, fn shell ->
        [
          {String.to_atom("test_linux_#{shell}"), installer_job("Linux", "ubuntu-latest", shell)},
          {String.to_atom("test_macos_#{shell}"), installer_job("macOS", "macos-latest", shell)}
        ]
      end)
  end

  defp installer_job(os, runner, shell) do
    install =
      if os == "Linux",
        do: "sudo apt-get update && sudo apt-get install -y expect #{shell}",
        else: "brew install expect #{if shell == "bash", do: "", else: shell}"

    [
      name: "Test #{os} script with #{shell} shell",
      "runs-on": runner,
      "timeout-minutes": 35,
      env: [SHELL: shell, TZ: "America/New_York"],
      steps: [
        [uses: "actions/checkout@v4"],
        [name: "Install test tools", run: install],
        [
          name: "Test the script",
          run: "expect test/scripts/script.exp",
          shell: "#{shell} -l {0}",
          "timeout-minutes": 25
        ],
        [
          name: "Generate an app and start the server",
          run: smoke_app(),
          shell: "#{shell} -l {0}"
        ],
        [
          name: "Check HTTP status code",
          shell: "bash",
          run: """
          for attempt in {1..30}; do
            if curl --fail --silent --max-time 5 http://localhost:4000 > /dev/null; then exit 0; fi
            sleep 2
          done
          cat "$RUNNER_TEMP/phx_server.log"
          exit 1
          """
        ],
        [
          name: "Show server log on failure",
          if: "failure()",
          shell: "bash",
          run: "cat \"$RUNNER_TEMP/phx_server.log\" 2>/dev/null || true"
        ]
      ]
    ]
  end

  defp smoke_app do
    """
    cd "$RUNNER_TEMP" || exit 1
    mise exec -- mix phx.new --no-ecto --no-install phx_tools_test || exit 1
    cd phx_tools_test || exit 1
    mise exec -- mix setup || exit 1
    nohup mise exec -- mix phx.server > "$RUNNER_TEMP/phx_server.log" 2>&1 &
    """
  end
end
