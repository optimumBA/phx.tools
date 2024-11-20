defmodule PhxToolsWeb.PhxToolsComponents do
  @moduledoc false

  use PhxToolsWeb, :html

  alias Phoenix.LiveView.Utils
  alias PhxToolsWeb.PhxToolsLive.Icons
  alias PhxToolsWeb.PhxToolsLive.Index

  @type assigns :: map()
  @type rendered :: Phoenix.LiveView.Rendered.t()

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
                  class="hidden md:block w-6 h-6 text-white cursor-pointer focus:text-gray-500"
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
            <div class="w-full bg-blue-600 flex justify-center">
              <.os_instructions
                :let={installation_instruction}
                installation_instructions={installation_instructions(@live_action)}
                live_action={@live_action}
                operating_system={@operating_system}
              >
                <%= raw(installation_instruction) %>
              </.os_instructions>
            </div>

            <div class="  flex justify-center items-center gap-4 sm:py-4">
              <.source_code_button source_code_url={@source_code_url} />
            </div>
            <div class="-mt-6 md:mt-0">
              <p class=" md:hidden text-center text-white font-martian text-xs md:text-sm lg:text-base leading-5 md:leading-6 sm:py-8">
                <%= phx_tools_description() %>
              </p>
            </div>

            <div class="bg-[#110A33] rounded-[4px] shadow-lg text-white shadow-[#2C2650] blur-shadow max-w-[809px]">
              <div class="bg-[#2C2650] p-3 rounded-t-[4px] flex sm:flex-col md:flex-row sm:items-start md:items-center sm:space-y-2 md:space-y-0 md:space-x-4 sm:justify-start md:justify-center">
                <Icons.exclamation_icon />
                <p class="font-martian sm:text-sm md:text-base lg:text-lg md:py-2">
                  Unsupported Operating System Detected
                </p>
              </div>
              <p class="text-xs leading-5 md:leading-6 md:text-sm lg:text-base text-center sm:px-3 font-martian sm:py-6 md:px-8">
                It looks like you're using an operating system that Phx.tools doesn't currently support. This script is designed to work on Linux and macOS only. Please switch to a compatible operating system to continue.
              </p>
            </div>
            <p class="hidden md:block text-center text-white font-martian text-xs md:text-sm lg:text-base leading-5 md:leading-6 sm:py-8">
              <%= phx_tools_description() %>
            </p>
          </div>
          <.web_updates />
          <.footer />
        </div>
      </div>
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
                  class="hidden md:block w-6 h-6 text-white cursor-pointer focus:text-gray-500"
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
            <div class="w-full bg-blue-600 flex justify-center">
              <.os_instructions
                :let={installation_instruction}
                installation_instructions={installation_instructions(@live_action)}
                live_action={@live_action}
                operating_system={@operating_system}
              >
                <%= raw(installation_instruction) %>
              </.os_instructions>
            </div>
            <div class="justify-center gap-4 flex">
              <div class="sm:grid grid gap-4 sm:py-4">
                <.source_code_button source_code_url={@source_code_url} />
              </div>
            </div>
          </div>
          <div class="lg:w-[1100px]">
            <div>
              <p class="text-xs px-2 leading-5 text-center text-white font-martian md:mb-5 md:text-sm md:leading-6 lg:text-base">
                <%= phx_tools_description() %>
              </p>
            </div>
            <div
              class="mx-auto"
              data-asciicast={asciinema_cast_id(@live_action)}
              id={"asciinema-#{Utils.random_id()}"}
              phx-hook="AsciinemaHook"
            >
            </div>

            <.web_updates />
          </div>
        </div>
      </div>
      <.footer />
    </div>
    """
  end

  defp asciinema_cast_id(:macos), do: "689829"

  defp asciinema_cast_id(:linux), do: "689816"

  defp os_instructions(assigns) do
    ~H"""
    <div
      id="installation-instructions"
      phx-click-away={JS.hide(to: "#installation-instructions")}
      class="hidden font-normal solved-height font-martian bg-[#110A33] absolute md:w-[95%]"
    >
      <div class="block">
        <div class="h-full shadow-custom shadow-md rounded-md pb-2">
          <div class="text-start px-[3%] lg:text-xl md:text-lg sm:text-md">
            <h1 class="text-white text-center text-sm md:text-base lg:text-lg lg:my-[5%] md:my-[2%] sm:my-[2%] lg:pt-5">
              <%= Index.get_operating_system("#{@live_action}") %> installation process
            </h1>
            <ol class="list-decimal ml-3 pl-5 text-xs md:text-sm lg:text-base text-white lg:mt-4 sm:mt-2 leading-6">
              <%= for instruction <- @installation_instructions do %>
                <li class="mb-2">
                  <%= render_slot(@inner_block, instruction) %>
                </li>
              <% end %>
            </ol>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp installation_instructions(:linux) do
    [
      "Click on the copy icon to copy this command to your clipboard",
      "Open Terminal by pressing <b class=\"font-extrabold\">Ctrl + Alt + T</b> together",
      "Paste the shell command by pressing <b>Shift + Ctrl + V</b> together",
      "Run the command by hitting <b>ENTER</b>"
    ]
  end

  defp installation_instructions(:macos) do
    [
      "Click on the copy icon to copy this command to your clipboard",
      "Open Terminal by pressing <b class=\"font-extrabold\">⌘ + SPACE</b> together",
      "Type \"Terminal\" and hit <b>RETURN</b>",
      "Paste the shell command by hitting <b>⌘ + V</b> together",
      "Run the command by hitting <b>RETURN</b>"
    ]
  end

  defp installation_instructions(_) do
    [
      "Click on the copy icon to copy this command to your clipboard",
      "Open Terminal by pressing <b class=\"font-extrabold\">Ctrl + Alt + T</b> together",
      "Paste the shell command by pressing <b>Shift + Ctrl + V</b> together",
      "Run the command by hitting <b>ENTER</b>"
    ]
  end

  defp source_code_button(assigns) do
    ~H"""
    <div class="border-2 border-[#755FFF] py-4 rounded-xl cursor-pointer hover:bg-indigo-850 flex font-martian w-44 ">
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

  defp phx_tools_description do
    "Phx.tools is a shell script for Linux and macOS that configures the development environment for you in a few easy steps. Once you finish running the script, you'll be able to start the database server, create a new Phoenix application, and launch the server."
  end

  defp web_updates(assigns) do
    ~H"""
    <p class="text-white font-martian text-center text-xs md:text-sm md:px-12 lg:text-base leading-6 sm:pb-4">
      Read about website updates here -
      <a
        href="https://optimum.ba/blog/exciting-updates-to-phx-tools"
        target="_blank"
        class="text-[#24B2FF] underline"
      >
        https://optimum.ba/blog/exciting-updates-to-phx-tools
      </a>
    </p>
    """
  end
end
