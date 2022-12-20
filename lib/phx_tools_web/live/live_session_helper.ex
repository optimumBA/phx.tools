defmodule PhxToolsWeb.LiveSessionHelper do
  @moduledoc """
  This module takes user-agent data from session, then filters user operating
  system out of it.
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
    operating_system
    |> String.split(" ")
    |> List.first()
  end
end
