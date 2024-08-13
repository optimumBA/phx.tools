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
    <div class="solved-height  bg-[#110A33] md:ml-24">
      <div class="h-full shadow-[#C2B8FF33] shadow-md rounded-md lg:mx-[2%]">
        <div class="text-start px-[3%] lg:text-xl md:text-lg sm:text-md sm:py-4">
          <h1 class="text-white text-center lg:text-2xl md:text-[22px] sm:text-xl lg:my-[5%] sm:pb-3 ">
            <%= render_slot(@header) %>
          </h1>
          <%= for item <- @instruction do %>
            <h1 class="text-white ">
              <%= render_slot(item) %>
            </h1>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
