defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  alias PhxToolsWeb.Endpoint
  alias PhxToolsWeb.InstructionComponents
  alias PhxToolsWeb.PhxToolsLive.ButtonsComponents
  alias PhxToolsWeb.PhxToolsLive.LandingComponent
  # alias PhxToolsWeb.PhxToolsLive.MacLandingComponent

  @impl Phoenix.LiveView
  def mount(_params, session, socket), do: {:ok, assign_os(socket, session)}

  defp assign_os(socket, %{"operating_system" => operating_system}),
    do: assign(socket, :operating_system, operating_system)

  @impl Phoenix.LiveView
  def handle_params(_params, _uri, socket) do
    apply_action(socket, socket.assigns.live_action)
  end

  defp apply_action(socket, :index) do
    case socket.assigns.operating_system do
      "Linux" -> {:noreply, assign(socket, :live_action, :linux)}
      "Mac" -> {:noreply, assign(socket, :live_action, :macOS)}
      _other -> {:noreply, socket}
    end
  end

  defp apply_action(socket, :linux) do
    {:noreply, assign(socket, :live_action, :linux)}
  end

  defp apply_action(socket, :macOS) do
    {:noreply, assign(socket, :live_action, :macOS)}
  end
end
