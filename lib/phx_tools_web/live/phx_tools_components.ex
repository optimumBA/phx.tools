defmodule PhxToolsWeb.PhxToolsComponents do
  @moduledoc false

  use PhxToolsWeb, :html

  alias Phoenix.LiveView.Utils
  alias PhxToolsWeb.PhxToolsLive.Icons

  @type assigns :: map()
  @type rendered :: Phoenix.LiveView.Rendered.t()

  @spec command_select_button(assigns()) :: rendered()
  def command_select_button(assigns) do
    ~H"""
    <.os_link_button
      id={if @live_action == :macOS, do: "Linux", else: "macOS"}
      href={if @live_action == :macOS, do: ~p"/Linux", else: ~p"/macOS"}
      os_name={if @live_action == :Linux, do: "macOS", else: "Linux"}
      class="px-3 flex justify-center"
    />
    """
  end

  @spec footer(assigns()) :: rendered()
  def footer(assigns) do
    ~H"""
    <div class="relative flex items-center justify-center lg:mb-5 md:mb-8 sm:mb-9 mt-[5%] px-[30%]">
      <.link href="https://optimum.ba" target="_blank" class="flex items-center gap-3">
        <Icons.optimum_logo />
        <span class="font-bold font-montserrat text-white sm:text-sm md:text-lg lg:text-xl">
          OPTIMUM
        </span>
      </.link>
    </div>
    <p class="font-semibold text-center text-white text-xs md:text-sm lg:text-base  font-montserrat">
      Copyright <span>&copy; <%= Date.utc_today().year %></span> Optimum
    </p>
    """
  end

  attr :live_action, :atom, required: true
  attr :operating_system, :string, required: true
  attr :source_code_url, :string, required: true

  slot :installation_command, required: true
  @spec os_landing_card(assigns()) :: rendered()
  def os_landing_card(%{live_action: :index} = assigns) do
    ~H"""
    <div class="flex flex-col items-center max-w-5xl mx-auto">
      <div>
        <div class="sm:flex flex-col items-center">
          <Icons.phx_tools_svg class="h-7 md:h-12" />
          <p class="sm:py-6 text-center text-white text-sm md:text-base lg:text-lg font-martian font-semibold ">
            The Complete Development Environment for Elixir and Phoenix
          </p>
        </div>
      </div>
      <div class="flex flex-col items-center md:w-11/12 lg:w-[1100px]">
        <div class="bg-[#110A33] rounded-xl shadow-lg text-white shadow-[#2C2650] blur-shadow max-w-[809px]">
          <div class="bg-[#2C2650] p-3 rounded-t-xl flex sm:flex-col md:flex-row sm:items-start md:items-center sm:space-y-2 md:space-y-0 md:space-x-4 sm:justify-start md:justify-center">
            <Icons.exclamation_icon />
            <p class="font-martian sm:text-sm md:text-base lg:text-lg md:py-2">
              Unsupported Operating System Detected
            </p>
          </div>
          <p class="sm:text-xs leading-5 md:leading-6 md:text-sm lg:text-base text-center sm:px-3  font-martian sm:py-6 md:px-8">
            It looks like you're using an operating system that Phx.tools doesn't currently support. This script is designed to work on Linux and macOS only. Please switch to a compatible operating system to continue.
          </p>
          <div class="flex-col items-center text-sm sm:flex font-martian sm:pb-8 md:block md:text-center">
            <a href="https://phx.tools/macOS" class="text-[#24B2FF] underline">
              https://phx.tools/macOS
            </a>
            <span class="px-2">or</span>
            <a href="http://phx.tools/linux" class="text-[#24B2FF] underline">
              http://phx.tools/linux"
            </a>
          </div>
        </div>
        <p class="text-center text-white font-martian text-xs md:text-sm lg:text-base leading-5 md:leading-6 sm:py-8">
          Phx.tools is a shell script for Linux and macOS that configures the development environment for you in a few easy steps. Once you finish running the script, you'll be able to start the database server, create a new Phoenix application, and launch the server.
        </p>
      </div>
      <div class="">
        <p class="text-white font-martian text-center text-xs md:text-sm lg:text-base leading-6 sm:pb-4">
          Read about website updates here -
          <a
            href="https://optimum.ba/blog/exciting-updates-to-phx-tools"
            target="_blank"
            class="text-[#24B2FF] underline"
          >
            https://optimum.ba/blog/exciting-updates-to-phx-tools
          </a>
        </p>
      </div>
      <.footer />
    </div>
    """
  end

  def os_landing_card(assigns) do
    ~H"""
    <div class="solved-height">
      <div class="min-h-full">
        <div class="mt-[5%] md:flex flex-col items-center max-w-4xl mx-auto">
          <div class="sm:flex flex-col items-center">
            <Icons.phx_tools_svg class="h-7 md:h-12" />
            <p class="sm:py-6 text-center text-white text-sm md:text-base lg:text-lg font-martian font-semibold ">
              The Complete Development Environment for Elixir and Phoenix
            </p>
          </div>

          <div class="md:flex lg:w-[75%] flex-col relative">
            <div class="md:flex">
              <div class="flex justify-end items-center md:order-last md:mx-2 sm:mb-2">
                <Heroicons.information_circle
                  class="w-6 h-6 text-white cursor-pointer focus:text-gray-500"
                  phx-click={JS.show(to: "#installation-instructions")}
                />
              </div>
              <div class="border sm:px-3 bg-[#26168780] w-full flex items-center justify-center py-2 sm:space-x-3 rounded-sm overflow-x-auto whitespace-nowrap no-scrollbar">
                <h1 id="tool-installation" class="text-center text-white font-martian sm:text-sm">
                  <%= render_slot(@installation_command) %>
                </h1>
                <div id="copy" phx-hook="CopyHook" class="sm:py-3 md:my-0 cursor-pointer">
                  <Icons.copied_icon />
                  <Icons.copy_icon />
                </div>
              </div>
            </div>
            <div class="w-full bg-blue-600 flex justify-end">
              <.os_instructions live_action={@live_action} operating_system={@operating_system} />
            </div>
            <div class="justify-center gap-4 md:flex">
              <div class="sm:grid grid-cols-2 gap-4 sm:py-4">
                <.command_select_button
                  live_action={@live_action}
                  operating_system={@operating_system}
                />
                <.source_code_button source_code_url={@source_code_url} />
              </div>
            </div>
          </div>
          <div class="lg:w-[1100px]">
            <div>
              <p class="text-xs px-2 leading-5 text-center text-white font-martian md:mb-5 md:text-sm md:leading-6 lg:text-base">
                Phx.tools is a shell script for Linux and macOS that configures the development environment for you in a few easy steps. Once you finish running the script, you'll be able to start the database server, create a new Phoenix application, and launch the server.
              </p>
            </div>
            <div
              class="mx-auto"
              data-asciicast={
                if @live_action == :macOS,
                  do: "bJMOlPe5F4mFLY0Rl6fiJSOp3",
                  else: "XhDpRstBJ4df2gfiRfp0awDPO"
              }
              id={"asciinema-#{Utils.random_id()}"}
              phx-hook="AsciinemaHook"
            >
            </div>

            <p class="md:my-5 text-white md:px-12 text-xs md:text-sm lg:text-base font-martian">
              Read about website updates here -
              <a
                href="https://optimum.ba/blog/exciting-updates-to-phx-tools"
                class="text-[#24B2FF] font-martian text-sm underline"
                target="_blank"
              >
                https://optimum.ba/blog/exciting-updates-to-phx-tools
              </a>
            </p>
          </div>
        </div>
      </div>
      <.footer />
    </div>
    """
  end

  @spec os_instructions(assigns()) :: rendered()
  def os_instructions(assigns) do
    ~H"""
    <div
      id="installation-instructions"
      phx-click-away={JS.hide(to: "#installation-instructions")}
      class="hidden font-normal solved-height font-martian bg-[#110A33] absolute md:w-[90%]"
    >
      <div class="block">
        <div class="h-full shadow-[#C2B8FF] shadow-md rounded-md pb-2">
          <div class="text-start px-[3%] lg:text-xl md:text-lg sm:text-md">
            <h1 class="text-white text-center text-sm md:text-base lg:text-xl lg:my-[5%] md:my-[2%] sm:my-[2%] lg:pt-5">
              <%= @live_action %> installation process
            </h1>
            <ol class="list-decimal ml-3 pl-5 text-xs md:text-sm lg:text-base text-white lg:mt-4 sm:mt-2 leading-6">
              <%= for instruction <- render_instructions(@live_action) do %>
                <li class="mb-2"><%= raw(instruction) %></li>
              <% end %>
            </ol>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :class, :string
  attr :href, :string, required: true
  attr :os_name, :string, required: true

  @spec os_link_button(assigns()) :: rendered()
  def os_link_button(assigns) do
    ~H"""
    <.link href={@href}>
      <div
        id={@id}
        class={[
          "border-2 border-[#755FFF] py-2 rounded-xl cursor-pointer hover:bg-indigo-850 flex items-center md:w-44 space-x-2",
          @class
        ]}
      >
        <div class="bg-white w-6 h-6 rounded-full flex items-center justify-center">
          <Icons.os_icon os_name={@os_name} />
        </div>
        <h1 class="text-center text-white text-sm md:text-base font-martian"><%= @os_name %></h1>
      </div>
    </.link>
    """
  end

  defp render_instructions(live_action) do
    case live_action do
      :Linux ->
        [
          "Click on the copy icon to copy this command to your clipboard",
          "Open Terminal by pressing <b class=\"font-extrabold\">Ctrl + Alt + T</b> together",
          "Paste the shell command by pressing <b>Shift + Ctrl + V</b> together",
          "Run the command by hitting <b>ENTER</b>"
        ]

      :macOS ->
        [
          "Click on the copy icon to copy this command to your clipboard",
          "Open Terminal by pressing <b class=\"font-extrabold\">⌘ + SPACE</b> together",
          "Type \"Terminal\" and hit <b>RETURN</b>",
          "Paste the shell command by hitting <b>⌘ + V</b> together",
          "Run the command by hitting <b>RETURN</b>"
        ]
    end
  end

  attr :source_code_url, :string, required: true

  @spec source_code_button(assigns()) :: rendered()
  def source_code_button(assigns) do
    ~H"""
    <div class="border-2 border-[#755FFF] rounded-xl cursor-pointer hover:bg-indigo-850 flex font-martian md:w-44">
      <.link
        href={@source_code_url}
        target="_blank"
        class="flex items-center justify-center w-full space-x-2 text-sm rounded-xl"
      >
        <Heroicons.code_bracket class="bold w-5 h-5 text-white" />
        <span class="text-white text-sm md:text-base">Source code</span>
      </.link>
    </div>
    """
  end
end
