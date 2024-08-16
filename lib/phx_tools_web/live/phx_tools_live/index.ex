defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  alias PhxToolsWeb.Endpoint
  alias PhxToolsWeb.InstructionComponents
  alias PhxToolsWeb.PhxToolsLive.LandingComponent

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(:seo_attributes, %{})
     |> assign_os(session)}
  end

  defp assign_os(socket, %{"operating_system" => operating_system}),
    do: assign(socket, :operating_system, operating_system)

  @impl Phoenix.LiveView
  def handle_params(_params, _uri, socket),
    do: {:noreply, apply_action(socket, socket.assigns.live_action)}

  defp apply_action(socket, :linux) do
    assign(socket, seo_attributes: %{url: url(~p"/linux")})
  end

  defp apply_action(socket, :macOS) do
    assign(socket, seo_attributes: %{url: url(~p"/macOS")})
  end

  defp apply_action(socket, _index), do: socket
end
