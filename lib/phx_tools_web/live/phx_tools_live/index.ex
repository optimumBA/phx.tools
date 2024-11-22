defmodule PhxToolsWeb.PhxToolsLive.Index do
  use PhxToolsWeb, :live_view

  alias PhxToolsWeb.Endpoint
  alias PhxToolsWeb.PhxToolsComponents

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(:seo_attributes, %{url: Endpoint.url()})
     |> assign_os(session)}
  end

  defp assign_os(socket, %{"operating_system" => operating_system}) do
    os_type =
      case operating_system do
        "Linux" -> :linux
        "macOS" -> :macos
        _other -> :other
      end

    assign(socket, :os_type, os_type)
  end

  @spec get_operating_system(atom()) :: String.t()
  def get_operating_system(:macos), do: "macOS"
  def get_operating_system(_other), do: "Linux"
end
