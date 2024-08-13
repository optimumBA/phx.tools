defmodule PhxToolsWeb.PhxToolsLive.LandingComponent do
  @moduledoc """
  Shows the landing page
  """

  use PhxToolsWeb, :html
  alias Phoenix.LiveView.JS
  alias PhxToolsWeb.InstructionComponents

  attr :operating_system, :string

  slot :installation_command, required: true

  @spec landing_page(map()) :: Phoenix.LiveView.Rendered.t()
  def landing_page(assigns) do
    ~H"""
    <div class="relative flex flex-col min-h-full ">
      <%!-- header part --%>
      <div>
        <h1 class="font-extrabold text-center text-white lg:text-7xl md:text-xl sm:text-4xl font-pixelify">
          Phx.tools
        </h1>
        <p class="py-5 text-sm text-center text-white md:text-xl font-martian">
          The Complete Development Environment for Elixir and Phoenix
        </p>
      </div>

      <%!-- imstallation command section --%>
      <div id="phx-tools-guide" class="relative flex-col items-center md:mx-2 md:flex">
        <div class="w-full sm:py-2 md:flex md:w-10/12 lg:w-7/12">
          <div class="flex justify-end sm:py-4 md:py-0 md:order-last md:mx-2">
            <img src="/images/info_icon.svg" alt="installation command info" />
          </div>
          <div class="border sm:px-3 bg-[#26168780] w-full flex items-center justify-center py-2 sm:space-x-3">
            <h1 id="tool-installation" class="font-bold text-center text-white md:text-lg">
              <%= render_slot(@installation_command) %>
            </h1>
            <div id="copy" phx-hook="CopyHook" class="sm:py-3 md:my-0">
              <img
                src="/images/clipboard.svg"
                alt="copy icon"
                phx-click={JS.show(to: "#installation-instructions")}
              />
            </div>
          </div>
        </div>

        <%!-- instructions --%>
        <div
          id="installation-instructions"
          phx-click-away={JS.hide(to: "#installation-instructions")}
          class="absolute hidden w-full top-20 md:w-10/12 lg:w-8/12"
        >
          <InstructionComponents.os_instructions>
            <:header>
              Linux installation process
            </:header>

            <:instruction>
              1. Press the button to copy this command to your clipboard:
            </:instruction>
            <:instruction>
              2. Open Terminal by pressing <b class="font-extrabold">Ctrl + Alt + T</b> together
            </:instruction>

            <:instruction>
              3. Paste the shell command by pressing <b>Shift + Ctrl + V</b> together
            </:instruction>

            <:instruction>
              4. Run the command by hitting <b>ENTER</b>
            </:instruction>
          </InstructionComponents.os_instructions>
        </div>

        <%!-- control buttons --%>
        <div class="flex justify-between my-4">
          <div class="grid w-full grid-cols-2 gap-3 text-white">
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
            <div class="border-[2px] border-[#755FFF] rounded-xl cursor-pointer hover:bg-indigo-850 flex h-12 font-martian md:w-44">
              <button class="flex items-center justify-center w-full space-x-2 text-sm rounded-xl">
                <span><img src="/images/Icon.svg" alt="" /></span> <span>Source code</span>
              </button>
            </div>
          </div>
        </div>
      </div>
      <div>
        <p class="mb-6 text-center text-white font-martian sm:text-sm md:text-lg md:font-bold">
          Phx.tools is a shell script for Linux and macOS that configures the development environment for you in a few easy steps. Once you finish running the script, you'll be able to start the database server, create a new Phoenix application, and launch the server.
        </p>
      </div>
    </div>
    <div class="bg-[#2C2650] h-72 ">
      video
    </div>
    <div>
      <p class="text-white">
        Read about website updates here
        <a href="https://optimum.ba/blog/phx-tools-complete-development-environment-for-elixir-and-phoenix">
          <span class="text-[#24B2FF]">
            https://optimum.ba/blog/phx-tools-complete-development-environment-for-elixir-and-phoenix
          </span>
        </a>
      </p>
    </div>
    """
  end
end
