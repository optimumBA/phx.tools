defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, session, socket), do: {:ok, assign_os_param(socket, session)}

  defp assign_os_param(socket, %{"operating_system" => operating_system} = _session),
    do: assign(socket, :operating_system, operating_system)
end
