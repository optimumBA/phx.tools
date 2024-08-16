defmodule PhxToolsWeb.InstructionComponents do
  @moduledoc """
  Shows the steps to execute different scripts depending on the operating system.
  """
  use PhxToolsWeb, :html

  @type assigns :: map()
  @type rendered :: Phoenix.LiveView.Rendered.t()

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
end
