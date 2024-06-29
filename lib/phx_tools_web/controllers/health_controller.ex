defmodule PhxToolsWeb.HealthController do
  @moduledoc false

  use PhxToolsWeb, :controller

  @type conn :: Plug.Conn.t()
  @type params :: map()

  @spec index(conn(), params()) :: conn()
  def index(conn, _params) do
    {:ok, hostname} = :inet.gethostname()

    json(conn, %{
      connected_to: Node.list(),
      hostname: to_string(hostname),
      node: Node.self(),
      status: :ok
    })
  end
end
