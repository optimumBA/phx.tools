defmodule PhxToolsWeb.PhxToolsLive.LandingComponent do
  @moduledoc """
  Shows the landing page
  """
  use PhxToolsWeb, :html

  alias PhxToolsWeb.Endpoint
  alias PhxToolsWeb.PhxToolsLive.ButtonsComponents
  alias PhxToolsWeb.PhxToolsLive.InstructionsComponent

  slot :installation_command, required: true
  @spec landing_page(map()) :: Phoenix.LiveView.Rendered.t()
  def landing_page(assigns) do
    ~H"""
    <div class="solved-height">
      <div class="min-h-full">
        <div class=" mt-[5%]">
          <div>
            <h1 class="font-extrabold text-center text-white lg:text-7xl md:text-xl sm:text-4xl font-pixelify">
              Phx.tools
            </h1>
            <p class="py-5 text-center text-white md:text-md font-martian sm:text-xs">
              The Complete Development Environment for Elixir and Phoenix
            </p>
          </div>

          <div class="md:flex">
            <div class="flex justify-end sm:py-4 md:py-0 md:order-last md:mx-2">
              <img
                src="/images/info_icon.svg"
                alt="installation command info"
                phx-click={JS.show(to: "#installation-instructions")}
              />
            </div>
            <div class="border sm:px-3 bg-[#26168780] w-full flex items-center justify-center py-2 sm:space-x-3 rounded-sm">
              <h1 id="tool-installation" class="text-center text-white font-martian sm:text-sm">
                <%= render_slot(@installation_command) %>
              </h1>
              <div id="copy" phx-hook="CopyHook" class="sm:py-3 md:my-0">
                <img src="/images/clipboard.svg" alt="copy icon" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
