defmodule PhxToolsWeb.LandingPageLive.Index do
  use PhxToolsWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    socket = assign_os_param(socket, session)

    {:ok, socket}
  end

  defp assign_os_param(socket, %{"operating_system" => operating_system} = _session) do
    socket = assign(socket, :operating_system, operating_system)

    socket
  end
end
