defmodule PhxToolsWeb.PhxToolsLive.ButtonsComponents do
  use PhxToolsWeb, :html

  @spec render_buttons(map()) :: Phoenix.LiveView.Rendered.t()
  def render_buttons(assigns) do
    ~H"""
    <div class="w-full gap-3 text-white md:my-5">
      <div :if={@live_action == :linux} class="justify-center gap-4 md:flex" id="macOS-card">
        <.os_link_card
          id="macOS"
          href={~p"/macOS"}
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
          href={~p"/linux"}
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
    <div>
      <p class="text-sm text-center text-white font-martian md:mb-5">
        Phx.tools is a shell script for Linux and macOS that configures the development environment for you in a few easy steps. Once you finish running the script, you'll be able to start the database server, create a new Phoenix application, and launch the server.
      </p>
    </div>
    <div :if={@live_action == :macOS} class="mx-auto">
      <script
        src="https://asciinema.org/a/XhDpRstBJ4df2gfiRfp0awDPO.js"
        id="asciicast-XhDpRstBJ4df2gfiRfp0awDPO"
        async
      >
      </script>
    </div>
    <div :if={@live_action == :linux} class="mx-auto">
      <script
        src="https://asciinema.org/a/bJMOlPe5F4mFLY0Rl6fiJSOp3.js"
        id="asciicast-bJMOlPe5F4mFLY0Rl6fiJSOp3"
        async
      >
      </script>
    </div>
    <div class="md:my-5">
      <a
        href="https://optimum.ba/blog/phx-tools-complete-development-environment-for-elixir-and-phoenix"
        class="text-[#24B2FF] font-martian text-sm"
      >
        <span class="text-white">Read about website updates here -</span>
        https://optimum.ba/blog/phx-tools-complete-development-environment-for-elixir-and-phoenix
      </a>
    </div>
    """
  end
end
