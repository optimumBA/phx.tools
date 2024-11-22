defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  alias PhxToolsWeb.Endpoint
  alias PhxToolsWeb.PhxToolsComponents

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(:seo_attributes, %{url: Endpoint.url()})
      |> assign_os(session)

    case socket.assigns.operating_system do
      "Linux" -> {:ok, assign(socket, :live_action, :linux)}
      "macOS" -> {:ok, assign(socket, :live_action, :macos)}
      _other -> {:ok, socket}
    end
  end

  defp assign_os(socket, %{"operating_system" => operating_system}) do
    assign(socket, :operating_system, operating_system)
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
