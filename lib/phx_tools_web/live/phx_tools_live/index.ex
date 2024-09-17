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

  defp assign_os_and_source_code_url(socket, %{"operating_system" => operating_system}) do
    socket
    |> assign(:operating_system, operating_system)
    |> assign(:source_code_url, source_code_url_from_os_or_live_action(operating_system))
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
     |> assign(:source_code_url, source_code_url_from_os_or_live_action(action))}
  end

  defp installation_command(live_action) do
    "/bin/bash -c \"$(curl -fsSL #{get_script_url(live_action)})\""
  end

  defp source_code_url_from_os_or_live_action(os_or_live_action) do
    ~S(https://github.com/optimumBA/phx.tools/blob/main/priv/static/) <>
      get_script_filename(os_or_live_action)
  end

  defp get_script_url(live_action_or_os) do
    "#{Endpoint.url()}/#{get_script_filename(live_action_or_os)}"
  end

  defp get_script_filename(live_action_or_os) do
    "#{get_operating_system(to_string(live_action_or_os))}.sh"
  end

  @spec get_operating_system(String.t()) :: String.t()
  def get_operating_system(live_action_or_os) when live_action_or_os in ["linux", "Linux"],
    do: "Linux"

  def get_operating_system(live_action_or_os) when live_action_or_os in ["macos", "macOS"],
    do: "macOS"

  def get_operating_system(_other), do: "Unsupported OS"
end
