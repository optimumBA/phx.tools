defmodule PhxToolsWeb.PhxToolsComponents do
  @moduledoc false

  use PhxToolsWeb, :html

  alias PhxToolsWeb.PhxToolsLive.Icons

  attr :id, :string, required: true
  attr :class, :list
  attr :patch, :string, required: true
  attr :os_name, :string, required: true
  attr :source_code, :string, required: true

  @type assigns :: map()
  @type rendered :: Phoenix.LiveView.Rendered.t()

  @spec os_link_card(assigns()) :: rendered()
  def os_link_card(assigns) do
    ~H"""
    <div class="sm:grid grid-cols-2 gap-4 sm:py-4">
      <.link patch={@patch} target="_blank">
        <div
          id={@id}
          class={[
            "border-[2px] border-[#755FFF] py-2 rounded-xl cursor-pointer hover:bg-indigo-850 flex items-center md:w-44 space-x-2",
            @class
          ]}
        >
          <div class="bg-white w-6 h-6 rounded-full flex items-center justify-center">
            <Icons.os_icon os_name={@os_name} />
          </div>
          <h1 class="text-center text-white font-martian"><%= @os_name %></h1>
        </div>
      </.link>
      <div class="border-[2px] border-[#755FFF] rounded-xl cursor-pointer hover:bg-indigo-850 flex font-martian md:w-44">
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

  @spec footer(assigns()) :: rendered()
  def footer(assigns) do
    ~H"""
    <div class="relative flex items-center justify-center lg:mb-[22px] md:mb-[33px] sm:mb-[35px] mt-[5%] px-[30%]">
      <.link href="https://optimum.ba" target="_blank" class="flex items-center gap-3">
        <Icons.optimum_logo />
        <span class="font-bold font-montserrat text-white">OPTIMUM</span>
      </.link>
    </div>
    <p class="font-semibold text-center text-white font-montserrat">
      Copyright <span>&copy; <%= Date.utc_today().year %></span> Optimum
    </p>
    """
  end
end
