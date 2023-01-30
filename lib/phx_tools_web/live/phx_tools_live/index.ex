defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  alias PhxToolsWeb.Endpoint
  alias PhxToolsWeb.InstructionComponents
  alias PhxToolsWeb.PhxToolsLive.LandingComponent

  @impl Phoenix.LiveView
  def mount(_params, session, socket), do: {:ok, assign_url_and_os(socket, session)}

  defp assign_url_and_os(socket, %{"operating_system" => operating_system} = _session) do
    socket
    |> assign(:operating_system, operating_system)
    |> assign(:url, Endpoint.url)
  end

end
