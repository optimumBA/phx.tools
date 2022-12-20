defmodule PhxToolsWeb.PhxToolsLive.Linux do
  use PhxToolsWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
