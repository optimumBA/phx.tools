defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  alias PhxToolsWeb.InstructionComponents
  alias PhxToolsWeb.PhxToolsLive.LandingComponent

  @impl Phoenix.LiveView
  def mount(_params, session, socket), do: {:ok, assign_os(socket, session)}

  defp assign_os(socket, %{"operating_system" => operating_system}),
    do: assign(socket, :operating_system, operating_system)

  @impl Phoenix.LiveView
  def handle_params(_params, _uri, socket), do: {:noreply, socket}
end
