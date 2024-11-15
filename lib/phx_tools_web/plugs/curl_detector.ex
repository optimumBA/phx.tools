defmodule PhxToolsWeb.CurlDetector do
  @moduledoc """
  A plug that serves a script based on the request's `User-Agent` or specific URL paths.

  Requests from `curl` receive the script content directly, halting further processing. Additionally, requests to `/Linux.sh` or `/macOS.sh` paths return the script regardless of `User-Agent`.
  """

  import Plug.Conn

  @spec init(Keyword.t()) :: nil
  def init(_opts), do: nil

  @spec call(Plug.Conn.t(), nil) :: Plug.Conn.t()
  def call(conn, _opts) do
    user_agent =
      conn
      |> get_req_header("user-agent")
      |> List.first()

    if request_sent_from_curl?(user_agent) do
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(200, script_content())
      |> halt()
    else
      conn
    end
  end

  defp request_sent_from_curl?(user_agent) do
    user_agent && String.starts_with?(user_agent, "curl")
  end

  defp script_content do
    :phx_tools
    |> :code.priv_dir()
    |> Path.join("script.sh")
    |> File.read!()
  end
end
