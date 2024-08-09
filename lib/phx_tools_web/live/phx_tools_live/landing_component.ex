defmodule PhxToolsWeb.PhxToolsLive.LandingComponent do
  @moduledoc """
  Shows the landing page
  """

  use PhxToolsWeb, :html

  slot :installation_command, required: true

  @spec landing_page(map()) :: Phoenix.LiveView.Rendered.t()
  def landing_page(assigns) do
    ~H"""
    <div class="solved-height">
      <div class="flex items-center justify-center min-w-full min-h-full">
        <div class="block mt-[5%]">
          <div>
            <h1 class="font-extrabold text-center text-white lg:text-7xl md:text-xl sm:text-4xl font-martian bg-slate-500">
              Phx.tools
            </h1>
            <p class="py-5 text-center text-white">
              The Complete Development Environment for Elixir and Phoenix
            </p>
          </div>
          <div class="items-center justify-center md:flex sm:py-2">
            <div class="flex justify-end sm:py-4 md:order-last md:py-0">
              <img src="/images/info_icon.svg" alt="installation command info" class="md:ml-2" />
            </div>
            <div class="flex items-center py-2 border rounded-md justify-evenly sm:px-3">
              <h1 id="tool-installation" class="font-thin text-white ">
                <%= render_slot(@installation_command) %>
              </h1>
              <div id="copy" phx-hook="CopyHook" class="sm:pl-2 sm:my-5">
                <img src="/images/clipboard.svg" alt="copy icon" />
              </div>
            </div>
          </div>

          <div class="flex justify-between my-4">
            <div class="grid w-full grid-cols-2 gap-3 text-white">
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

              <div class="border-[2px] border-[#755FFF] rounded-xl cursor-pointer hover:bg-indigo-850 flex h-12 font-martian">
                <button class="flex items-center justify-center w-full space-x-2 text-sm rounded-xl">
                  <span><img src="/images/Icon.svg" alt="" /></span> <span>Source code</span>
                </button>
              </div>
            </div>
            <div :if={@operating_system == Linux}>
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
          </div>
          <div>
            <p class="text-center text-white font-martian sm:text-sm">
              Phx.tools is a shell script for Linux and macOS that configures the development environment for you in a few easy steps. Once you finish running the script, you'll be able to start the database server, create a new Phoenix application, and launch the server.
            </p>
          </div>

          <%!-- <%= if @operating_system do %>
            <h1 id="confirmation" class="text-center text-white text-xl mt-[20%]">
              Confirm your choice by clicking
            </h1>
          <% end %> --%>
        </div>
      </div>
    </div>
    """
  end
end
