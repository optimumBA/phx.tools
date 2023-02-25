defmodule PhxToolsWeb.LiveSessionHelper do
  @moduledoc """
  Takes the operating system from the session and passes it to the LiveView session.
  """
  alias Plug.Conn

  @spec get_system_name(Plug.Conn.t()) :: map()
  def get_system_name(conn) do
    operating_system = Conn.get_session(conn, :operating_system)

    case get_os_name(operating_system) do
      "Linux" ->
        %{"operating_system" => "Linux"}

      "Mac" ->
        %{"operating_system" => "Mac"}

      _other ->
        %{"operating_system" => operating_system}
    end
  end

  defp get_os_name(nil), do: nil

  defp get_os_name(operating_system) do
    os_name =
      operating_system
      |> String.split(" ")
      |> Enum.fetch!(0)

    os_name
  end
end
