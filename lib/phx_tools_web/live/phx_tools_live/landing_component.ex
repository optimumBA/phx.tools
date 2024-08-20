defmodule PhxToolsWeb.PhxToolsLive.LandingComponent do
  @moduledoc """
  Shows the landing page
  """
  use PhxToolsWeb, :html

  alias Phoenix.LiveView.Utils
  alias PhxToolsWeb.PhxToolsComponents
  alias PhxToolsWeb.PhxToolsLive.ButtonComponents
  alias PhxToolsWeb.PhxToolsLive.Icons
  alias PhxToolsWeb.PhxToolsLive.RenderInstructionComponent

  attr :live_action, :atom, required: true
  attr :operating_system, :string, required: true

  slot :installation_command, required: true
  @spec landing_page(map()) :: Phoenix.LiveView.Rendered.t()
  def landing_page(assigns) do
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
              <div class="flex justify-end items-center md:order-last md:mx-2">
                <Heroicons.information_circle
                  class="w-6 h-6 text-white cursor-pointer"
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
              <RenderInstructionComponent.render_instructions
                live_action={@live_action}
                operating_system={@operating_system}
              />
            </div>
            <div class="justify-center gap-4 md:flex">
              <ButtonComponents.button
                live_action={@live_action}
                operating_system={@operating_system}
              />
            </div>
          </div>
          <div>
            <div>
              <p class="text-sm text-center text-white font-martian md:mb-5 ">
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

            <p class="md:my-5 text-white">
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
      <PhxToolsComponents.footer />
    </div>
    """
  end
end
