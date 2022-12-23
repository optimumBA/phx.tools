defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  alias PhxToolsWeb.Endpoint
  alias PhxToolsWeb.InstructionComponents
  alias PhxToolsWeb.PhxToolsLive.LandingComponent

  @impl Phoenix.LiveView
  def mount(_params, session, socket), do: {:ok, assign_os_param(socket, session)}

  defp assign_os_param(socket, %{"operating_system" => operating_system} = _session),
    do: assign(socket, :operating_system, operating_system)

  @impl Phoenix.LiveView
  def handle_params(_params, _url, socket) do
    url = Endpoint.url()
    {:noreply, apply_action(socket, url)}
  end

  defp apply_action(socket, url) do
    socket = assign(socket, :url, url)
    socket
  end
end
