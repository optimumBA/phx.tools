defmodule PhxToolsWeb.SystemDetector do
  @moduledoc """
  Parses User-Agent and saves it to the session.
  """
  @behaviour Plug

  alias Plug.Conn

  @spec init(Keyword.t()) :: nil
  def init(_opts), do: nil

  @spec call(Plug.Conn.t(), nil) :: Plug.Conn.t()
  def call(%Conn{} = conn, _opts), do: Conn.put_session(conn, :operating_system, parse_user_agent(conn))

  defp parse_user_agent(conn) do
    conn
    |> Conn.get_req_header("user-agent")
    |> List.first()
    |> UAParser.parse()
  end
end
