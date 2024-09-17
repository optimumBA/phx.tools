defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  alias PhxToolsWeb.Endpoint
  alias PhxToolsWeb.PhxToolsComponents

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(:seo_attributes, %{})
     |> assign_os_and_source_code_url(session)}
  end

  defp assign_os_and_source_code_url(socket, %{"operating_system" => "Linux"}) do
    socket
    |> assign(:operating_system, "Linux")
    |> assign(:source_code_url, source_code_url("linux"))
  end

  defp assign_os_and_source_code_url(socket, %{"operating_system" => operating_system}) do
    socket
    |> assign(:operating_system, operating_system)
    |> assign(:source_code_url, source_code_url(operating_system))
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

  defp apply_action(socket, action) do
    {:noreply,
     socket
     |> assign(seo_attributes: %{url: Endpoint.url() <> "/#{action}"})
     |> assign(:source_code_url, source_code_url(action))}
  end

  defp installation_command(live_action) do
    "/bin/bash -c \"$(curl -fsSL #{Endpoint.url() <> "/#{get_os_from_live_action("#{live_action}")}.sh"})\""
  end

  defp source_code_url(live_action) do
    "https://github.com/optimumBA/phx.tools/blob/main/priv/static/#{get_os_from_live_action("#{live_action}")}.sh"
  end

  @spec get_os_from_live_action(String.t()) :: String.t()
  def get_os_from_live_action("linux"), do: "Linux"

  def get_os_from_live_action("macos"), do: "macOS"

  def get_os_from_live_action(_other), do: "Unsupported OS"
end
