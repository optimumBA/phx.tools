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
    |> assign(:source_code_url, source_code_url(operating_system))
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _uri, socket) do
    apply_action(socket, socket.assigns.live_action)
  end

  defp apply_action(socket, :index) do
    case socket.assigns.operating_system do
      "Linux" -> {:noreply, assign(socket, :live_action, :linux)}
      "macOS" -> {:noreply, assign(socket, :live_action, :macOS)}
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
    "/bin/bash -c \"$(curl -fsSL #{Endpoint.url() <> "/#{live_action}.sh"})\""
  end

  defp source_code_url(os) do
    "https://github.com/optimumBA/phx.tools/blob/main/priv/static/#{os}.sh"
  end
end
