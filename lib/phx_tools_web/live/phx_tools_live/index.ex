defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  alias PhxToolsWeb.Endpoint
  alias PhxToolsWeb.PhxToolsComponents

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(:seo_attributes, %{})
     |> assign_os(session)}
  end

  defp assign_os(socket, %{"operating_system" => operating_system}) do
    assign(socket, :operating_system, operating_system)
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _uri, socket) do
    apply_action(socket, socket.assigns.live_action)
  end

  defp apply_action(socket, :index) do
    case socket.assigns.operating_system do
      "Linux" -> {:noreply, assign(socket, :live_action, :linux)}
      "macOS" -> {:noreply, assign(socket, :live_action, :macos)}
      _other -> {:noreply, socket}
    end
  end

  defp apply_action(socket, _action) do
    {:noreply, assign(socket, seo_attributes: %{url: Endpoint.url()})}
  end

  defp installation_command do
    "$SHELL -c \"$(curl -fsSL #{Endpoint.url()})\""
  end

  @spec get_operating_system(String.t()) :: String.t()
  def get_operating_system(live_action_or_os) when live_action_or_os in ["linux", "Linux"],
    do: "Linux"

  def get_operating_system(live_action_or_os) when live_action_or_os in ["macos", "macOS"],
    do: "macOS"

  def get_operating_system(_other), do: "Linux"
end
