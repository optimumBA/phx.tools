defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  alias PhxToolsWeb.InstructionComponents

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(page: nil)
      |> assign_os_param(session)

    {:ok, socket}
  end

  defp assign_os_param(socket, %{"operating_system" => operating_system} = _session),
    do: assign(socket, :operating_system, operating_system)

  @impl Phoenix.LiveView
  def handle_params(_params, _url, socket) do
    socket = assign(socket, page: socket.assigns.live_action)
    {:noreply, socket}
  end
end
