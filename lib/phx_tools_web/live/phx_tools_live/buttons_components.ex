defmodule PhxToolsWeb.PhxToolsLive.ButtonsComponents do
  use PhxToolsWeb, :html

  def render_buttons(assigns) do
    ~H"""
    <div class="grid w-full grid-cols-2 gap-3 text-white md:my-5">
      <div :if={@operating_system == "Linux"} class="justify-end md:flex">
        <.os_link_card
          id="macOS"
          href={~p"/macOS"}
          os_icon={~p"/images/macos.png"}
          os_name="macOS"
          class={[
            "px-3 flex justify-center",
            @operating_system == "Mac" && "bg-indigo-850"
          ]}
        />
      </div>
      <div :if={@operating_system == "Mac"}>
        <.os_link_card
          id="linux"
          href={~p"/linux"}
          os_icon={~p"/images/linux.png"}
          os_name="Linux"
          class={[
            "px-1",
            @operating_system == "Linux" && "bg-indigo-850"
          ]}
        />
      </div>
      <div class="border-[2px] border-[#755FFF] rounded-xl cursor-pointer hover:bg-indigo-850 flex font-martian md:w-44">
        <button class="flex items-center justify-center w-full space-x-2 text-sm rounded-xl">
          <span><img src="/images/Icon.svg" alt="" /></span> <span>Source code</span>
        </button>
      </div>
    </div>
    <div>
      <p class="text-sm text-center text-white font-martian md:mb-5">
        Phx.tools is a shell script for Linux and macOS that configures the development environment for you in a few easy steps. Once you finish running the script, you'll be able to start the database server, create a new Phoenix application, and launch the server.
      </p>
    </div>
    <div class="h-64 bg-[#2C2650]">
            video
    </div>
    <div class="md:my-5">
            <a href="https://optimum.ba/blog/phx-tools-complete-development-environment-for-elixir-and-phoenix" class="text-[#24B2FF] font-martian text-sm"><span class="text-white">Read about website updates here -</span> https://optimum.ba/blog/phx-tools-complete-development-environment-for-elixir-and-phoenix</a>
    </div>
    """
  end
end
