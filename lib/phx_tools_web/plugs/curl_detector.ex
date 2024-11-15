defmodule PhxToolsWeb.CurlDetector do
  @moduledoc """
  A plug that serves a script based on the request's `User-Agent` or specific URL paths.

  Requests from `curl` receive the script content directly, halting further processing. Additionally, requests to `/Linux.sh` or `/macOS.sh` paths return the script regardless of `User-Agent`.
  """

  import Plug.Conn

  require Logger

  @script_path "priv/script.sh"

  @spec init(Keyword.t()) :: nil
  def init(opts), do: nil

  @spec call(Plug.Conn.t(), nil) :: Plug.Conn.t()
  def call(conn, _opts) do
    user_agent =
      conn
      |> get_req_header("user-agent")
      |> List.first()

    Logger.info("User-Agent: #{user_agent}==========")
    path = conn.request_path
    Logger.info("User-Agent: #{path}==========")

    if should_serve_script?(user_agent, path) do
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(200, script_content())
      |> halt()
    else
      conn
    end
  end

  defp should_serve_script?(user_agent, path) do
    curl_user_agent?(user_agent) || path in ["/Linux.sh", "/macOS.sh"]
  end

  defp curl_user_agent?(user_agent) do
    user_agent && String.starts_with?(user_agent, "curl")
  end

  defp script_content do
    script_path = Path.join(:code.priv_dir(:phx_tools), "script.sh")
    File.read!(script_path)
  end
end
