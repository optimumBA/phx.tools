defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  alias PhxToolsWeb.Endpoint
  alias PhxToolsWeb.PhxToolsComponents
  alias PhxToolsWeb.PhxToolsLive.UnsupportedOsComponent

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
    {:noreply,
     socket
     |> assign(:live_action, :linux)
     |> assign(seo_attributes: %{url: url(~p"/linux")})}
  end

  defp apply_action(socket, :macOS) do
    {:noreply,
     socket
     |> assign(:live_action, :macOS)
     |> assign(seo_attributes: %{url: url(~p"/macOS")})}
  end
end
