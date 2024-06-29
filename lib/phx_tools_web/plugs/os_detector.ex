defmodule PhxToolsWeb.SystemDetector do
  @moduledoc """
  Parses User-Agent and saves it to the session.
  """

  alias Plug.Conn

  @behaviour Plug

  @spec init(Keyword.t()) :: nil
  def init(_opts), do: nil

  @spec call(Plug.Conn.t(), nil) :: Plug.Conn.t()
  def call(%Conn{} = conn, _opts),
    do: Conn.put_session(conn, :operating_system, parse_user_agent(conn))

  defp parse_user_agent(conn) do
    user_agent =
      conn
      |> Conn.get_req_header("user-agent")
      |> List.first()
      |> UAParser.parse()

    user_agent.os.family
  end
end
