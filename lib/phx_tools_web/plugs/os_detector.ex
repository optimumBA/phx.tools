defmodule PhxToolsWeb.OsDetector do
  @moduledoc """
  This plug detect user-agent from conn, takes data and save it into session.
  """
  @behaviour Plug

  alias Plug.Conn

  @spec init(any) :: nil
  def init(_opts), do: nil

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(%Conn{} = conn, _opts) do
    conn = Conn.put_session(conn, :operating_system, get_user_os(conn))
    conn
  end

  defp get_user_os(conn) do
    user_agent =
      conn
      |> Conn.get_req_header("user-agent")
      |> List.first()
      |> UAParser.parse()

    user_agent
  end
end
