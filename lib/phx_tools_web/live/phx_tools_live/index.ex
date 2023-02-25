defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  alias PhxToolsWeb.Endpoint
  alias PhxToolsWeb.InstructionComponents
  alias PhxToolsWeb.PhxToolsLive.LandingComponent

  @impl Phoenix.LiveView
  def mount(_params, session, socket), do: {:ok, assign_url_and_os(socket, session)}

  @impl Phoenix.LiveView
  def handle_params(_params, _uri, socket), do: {:noreply, assign_url_and_os(socket)}

  defp assign_url_and_os(socket, session \\ %{})

  defp assign_url_and_os(socket, %{"operating_system" => operating_system}) do
    socket
    |> assign(:operating_system, operating_system)
    |> assign(:url, Endpoint.url())
  end

  defp assign_url_and_os(socket, %{}) do
    operating_system = Map.get(socket.assigns, :operating_system)

    socket
    |> assign(:operating_system, operating_system)
    |> assign(:url, Endpoint.url())
  end
end
