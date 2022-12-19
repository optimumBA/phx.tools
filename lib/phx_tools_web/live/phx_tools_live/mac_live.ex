defmodule PhxToolsWeb.PhxToolsLive.MacLive do
  use PhxToolsWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
