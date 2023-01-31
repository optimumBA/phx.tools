defmodule PhxToolsWeb.InstructionComponents do
  @moduledoc """
  Shows the steps to execute different scripts depending on the operating system.
  """
  use PhxToolsWeb, :html
  use Phoenix.Component

  @type assigns :: map()
  @type rendered :: Phoenix.LiveView.Rendered.t()

  slot :header, required: true
  slot :command_to_install, required: true
  slot :instruction_item, required: true

  @spec os_instructions(assigns()) :: rendered()
  def os_instructions(assigns) do
    ~H"""
    <div class="solved-height font-normal">
      <div class="w-full h-full flex items-center justify-center">
        <div class="block lg:mt-[3%] ">
          <h1 class="text-white text-center lg:text-[24px] md:text-[22px] sm:text-[20px] lg:mb-[5%] md:mb-[2%] sm:mb-[2%]">
            <%= render_slot(@header) %>
          </h1>
          <div class="h-full w-full border-[4px] shadow-[#28177E] shadow-md border-[#211666] rounded-md lg:mx-[2%] pb-2">
            <div class="text-start px-[3%] lg:text-[20px] md:text-[18px] sm:text-[15px]">
              <h1 class="text-white lg:mt-5 md:mt-5 sm:mt-4">
                1. Press the button to copy this command to your clipboard:
              </h1>
              <div class="flex items-center justify-evenly border-[1px] border-[#755FFF] py-1 mx-[4%] lg:mt-6 md:mt-5 sm:mt-4 rounded-lg">
                <h1 id="tool-installation" class="text-white  text-[16px] font-thin">
                  <%= render_slot(@command_to_install) %>
                </h1>
                <button
                  id="copy"
                  phx-hook="CopyHook"
                  class="text-white bg-[#755FFF] py-1 px-2 rounded-lg text-[16px]  lg:text-[16px] md:text-[15px] sm:text-[14px]"
                >
                  Copy
                </button>
              </div>

              <%= for item <- @instruction_item do %>
                <h1 class="text-white lg:mt-4 md:mt-5 sm:mt-4">
                  <%= render_slot(item) %>
                </h1>
              <% end %>
            </div>
          </div>
          <.link navigate={~p"/"}>
            <button class="border-[#755FFF] border-[1px] lg:mt-8 md:mt-5 sm:mt-5 p-1 text-[#755FFF] text-[16px] rounded-md lg:ml-3">
              Back
            </button>
          </.link>
        </div>
      </div>
    </div>
    """
  end
end
