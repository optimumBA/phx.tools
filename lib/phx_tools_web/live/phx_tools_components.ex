defmodule PhxToolsWeb.PhxToolsComponents do
  @moduledoc false

  use PhxToolsWeb, :html

  alias Phoenix.LiveView.Utils
  alias PhxToolsWeb.PhxToolsLive.Icons

  @type assigns :: map()
  @type rendered :: Phoenix.LiveView.Rendered.t()

  @spec button(assigns()) :: rendered()
  def button(%{live_action: :linux} = assigns) do
    ~H"""
    <.os_link_card
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
    <.os_link_card
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

  @spec footer(assigns()) :: rendered()
  def footer(assigns) do
    ~H"""
    <div class="relative flex items-center justify-center lg:mb-5 md:mb-8 sm:mb-9 mt-[5%] px-[30%]">
      <.link href="https://optimum.ba" target="_blank" class="flex items-center gap-3">
        <Icons.optimum_logo />
        <span class="font-bold font-montserrat text-white sm:text-sm md:text-xl">OPTIMUM</span>
      </.link>
    </div>
    <p class="font-semibold text-center text-white sm:text-sm md:text-base  font-montserrat">
      Copyright <span>&copy; <%= Date.utc_today().year %></span> Optimum
    </p>
    """
  end

  attr :live_action, :atom, required: true
  attr :operating_system, :string, required: true

  slot :installation_command, required: true
  @spec os_landing_card(assigns()) :: rendered()
  def os_landing_card(assigns) do
    ~H"""
    <div class="solved-height">
      <div class="min-h-full">
        <div class="mt-[5%] md:flex flex-col items-center max-w-5xl mx-auto">
          <div class="sm:flex flex-col items-center">
            <Icons.phx_tools_svg class="sm:w-4/12" />
            <p class="sm:py-6 text-center text-white md:text-md font-martian text-[14px] font-semibold ">
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
                  <Icons.clipboard_icon />
                </div>
              </div>
            </div>
            <div class="w-full bg-blue-600 flex justify-end">
              <.render_instructions live_action={@live_action} operating_system={@operating_system} />
            </div>
            <div class="justify-center gap-4 md:flex">
              <.button live_action={@live_action} operating_system={@operating_system} />
            </div>
          </div>
          <div class="lg:w-[1200px]">
            <div>
              <p class="text-sm text-center text-white font-martian md:mb-5 md:text-lg">
                Phx.tools is a shell script for Linux and macOS that configures the development environment for you in a few easy steps. Once you finish running the script, you'll be able to start the database server, create a new Phoenix application, and launch the server.
              </p>
            </div>
            <div
              class="mx-auto"
              data-live_action={@live_action}
              id={"asciinema-#{Utils.random_id()}"}
              phx-hook="AsciinemaHook"
            >
            </div>

            <p class="md:my-5 text-white md:px-12 md:text-lg">
              Read about website updates here -
              <a
                href="https://optimum.ba/blog/phx-tools-complete-development-environment-for-elixir-and-phoenix"
                class="text-[#24B2FF] font-martian text-sm underline"
                target="_blank"
              >
                https://optimum.ba/blog/phx-tools-complete-development-environment-for-elixir-and-phoenix
              </a>
            </p>
          </div>
        </div>
      </div>
      <.footer />
    </div>
    """
  end

  slot :header, required: true
  slot :instruction, required: true

  @spec os_instructions(assigns()) :: rendered()
  def os_instructions(assigns) do
    ~H"""
    <div
      id="installation-instructions"
      phx-click-away={JS.hide(to: "#installation-instructions")}
      class="hidden font-normal solved-height font-martian  bg-[#110A33] absolute md:w-[90%]"
    >
      <div class="block ">
        <div class="h-full shadow-[#28177E] shadow-md rounded-md pb-2">
          <div class="text-start px-[3%] lg:text-xl md:text-lg sm:text-md">
            <h1 class="text-white text-center lg:text-2xl md:text-[22px] sm:text-xl lg:my-[5%] md:my-[2%] sm:my-[2%] lg:pt-5">
              <%= render_slot(@header) %>
            </h1>
            <%= for item <- @instruction do %>
              <h1 class="text-[12px] text-white lg:mt-4 sm:mt-4">
                <%= render_slot(item) %>
              </h1>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :class, :list
  attr :patch, :string, required: true
  attr :os_name, :string, required: true
  attr :source_code, :string, required: true

  @spec os_link_card(assigns()) :: rendered()
  def os_link_card(assigns) do
    ~H"""
    <div class="sm:grid grid-cols-2 gap-4 sm:py-4">
      <.link patch={@patch} target="_blank">
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
          <h1 class="text-center text-white font-martian"><%= @os_name %></h1>
        </div>
      </.link>
      <div class="border-2 border-[#755FFF] rounded-xl cursor-pointer hover:bg-indigo-850 flex font-martian md:w-44">
        <.link
          href={@source_code}
          target="_blank"
          class="flex items-center justify-center w-full space-x-2 text-sm rounded-xl"
        >
          <Heroicons.code_bracket class="bold w-5 h-5 text-white" />
          <span class="text-white">Source code</span>
        </.link>
      </div>
    </div>
    """
  end

  attr :live_action, :string, required: true
  attr :operating_system, :string, required: true

  @spec render_instructions(assigns()) :: rendered()
  def render_instructions(assigns) do
    ~H"""
    <%= case @live_action do %>
      <% :linux -> %>
        <.os_instructions>
          <:header>
            Linux installation process
          </:header>

          <:instruction>
            1. Click on the copy icon to copy this command to your clipboard
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
        </.os_instructions>
      <% :macOS -> %>
        <.os_instructions>
          <:header>
            macOS installation process
          </:header>

          <:instruction>
            1. Click on the copy icon to copy this command to your clipboard
          </:instruction>

          <:instruction>
            2. Open Terminal by pressing <b class="font-extrabold"> ⌘ + SPACE </b> together
          </:instruction>

          <:instruction>
            3. Type "Terminal" and hit <b>RETURN</b>
          </:instruction>

          <:instruction>
            4. Paste the shell command by hitting<b> ⌘ + V </b> together.
          </:instruction>

          <:instruction>
            5. Run the command by hitting <b>RETURN</b>
          </:instruction>
        </.os_instructions>
    <% end %>
    """
  end
end
