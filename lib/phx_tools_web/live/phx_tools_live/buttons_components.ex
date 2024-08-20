defmodule PhxToolsWeb.PhxToolsLive.ButtonsComponents do
  use PhxToolsWeb, :html

  @spec render_buttons(map()) :: Phoenix.LiveView.Rendered.t()
  def render_buttons(assigns) do
    ~H"""
    <div>
      <div :if={@live_action == :linux} class="justify-center gap-4 md:flex" id="macOS-card">
        <.os_link_card
          id="macOS"
          patch={~p"/macOS"}
          os_icon={~p"/images/macos.png"}
          os_name="macOS"
          source_code="https://github.com/optimumBA/phx.tools/blob/main/priv/static/Linux.sh"
          class={[
            "px-3 flex justify-center",
            @operating_system == "Mac" && "bg-indigo-850"
          ]}
        />
      </div>
      <div :if={@live_action == :macOS} class="justify-center gap-4 md:flex" id="linux-card">
        <.os_link_card
          id="linux"
          patch={~p"/linux"}
          os_icon={~p"/images/linux.png"}
          os_name="Linux"
          source_code="https://github.com/optimumBA/phx.tools/blob/main/priv/static/macOS.sh"
          class={[
            "px-3 flex justify-center",
            @operating_system == "Linux" && "bg-indigo-850"
          ]}
        />
      </div>
    </div>
    """
  end
end
