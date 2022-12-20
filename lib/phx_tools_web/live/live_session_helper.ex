defmodule PhxToolsWeb.LiveSessionHelper do
  @moduledoc """
  This module takes user-agent data from session, then filters user operating
  system out of it.
  """
  alias Plug.Conn

  @spec get_os_version(Plug.Conn.t()) :: map()
  def get_os_version(conn) do
    operating_system = Conn.get_session(conn, :operating_system)

    case get_os_name(operating_system.os.family) do
      "Linux" ->
        %{"operating_system" => "Linux"}

      "Mac" ->
        %{"operating_system" => "Mac"}

      _other ->
        %{"operating_system" => operating_system}
    end
  end

  @spec get_os_name(nil | binary) :: binary()
  def get_os_name(nil = operating_system) do
    operating_system
  end

  def get_os_name(operating_system) do
    os_name =
      operating_system
      |> String.split(" ")
      |> List.first()

    os_name
  end
end