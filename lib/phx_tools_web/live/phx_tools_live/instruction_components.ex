defmodule PhxToolsWeb.InstructionComponents do
  @moduledoc """
  Shows the steps to execute different scripts depending on the operating system.
  """
  use PhxToolsWeb, :html

  @type assigns :: map()
  @type rendered :: Phoenix.LiveView.Rendered.t()

  slot :header, required: true
  slot :installation_command, required: true
  slot :instruction, required: true

  @spec os_instructions(assigns()) :: rendered()
  def os_instructions(assigns) do
    ~H"""
    <div class="font-normal solved-height">
      <div class="flex items-center justify-center w-full h-full">
        <div class="block lg:mt-[3%] ">
          <h1 class="text-white text-center lg:text-2xl md:text-[22px] sm:text-xl lg:mb-[5%] md:mb-[2%] sm:mb-[2%]">
            <%= render_slot(@header) %>
          </h1>
          <div class="h-full w-full border-4 shadow-[#28177E] shadow-md border-[#211666] rounded-md lg:mx-[2%] pb-2">
            <div class="text-start px-[3%] lg:text-xl md:text-lg sm:text-md">
              <%= for item <- @instruction do %>
                <h1 class="text-white lg:mt-4 md:mt-5 sm:mt-4">
                  <%= render_slot(item) %>
                </h1>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
