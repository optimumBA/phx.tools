defmodule PhxToolsWeb.PhxToolsLive.ButtonComponents do
  use PhxToolsWeb, :html

  alias PhxToolsWeb.PhxToolsComponents

  @type assigns :: map()
  @type rendered :: Phoenix.LiveView.Rendered.t()

  @spec button(assigns()) :: rendered()
  def button(%{live_action: :linux} = assigns) do
    ~H"""
    <PhxToolsComponents.os_link_card
      id="macOS"
      patch={~p"/macOS"}
      os_name="macOS"
      source_code="https://github.com/optimumBA/phx.tools/blob/main/priv/static/Linux.sh"
      class={[
        "px-3 flex justify-center",
        @operating_system == "Mac" && "bg-indigo-850"
      ]}
    />
    """
  end

  def button(%{live_action: :macOS} = assigns) do
    ~H"""
    <PhxToolsComponents.os_link_card
      id="linux"
      patch={~p"/linux"}
      os_name="Linux"
      source_code="https://github.com/optimumBA/phx.tools/blob/main/priv/static/macOS.sh"
      class={[
        "px-3 flex justify-center",
        @operating_system == "Linux" && "bg-indigo-850"
      ]}
    />
    """
  end
end
