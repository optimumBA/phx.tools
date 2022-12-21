defmodule PhxToolsWeb.InstructionComponents do
  @moduledoc """
  This module conditionaly renders page
  """
  use PhxToolsWeb, :live_component

  @spec render(map()) :: Phoenix.LiveView.Rendered.t()
  def render(%{page: :linux} = assigns) do
    ~H"""
    <div class="solved-height font-normal">
      <div class="w-full h-full flex items-center justify-center">
        <div class="block lg:mt-[3%] ">
          <h1 class="text-white text-center lg:text-[24px] md:text-[22px] sm:text-[20px] lg:mb-[5%] md:mb-[2%] sm:mb-[2%]">
            Linux installation process
          </h1>
          <div class="lg:w-[671px] lg:h-[272px] md:w-[661px] md:h-[290px] sm:w-[330px] sm:h-[350px] border-[4px] shadow-[#28177E] shadow-md border-[#211666] rounded-md lg:mx-[2%]">
            <div class="text-start px-[3%] lg:text-[20px] md:text-[18px] sm:text-[15px]">
              <h1 class="text-white lg:mt-5 md:mt-5 sm:mt-4">
                1. Press the button to copy this command to your clipboard:
              </h1>
              <div class="flex items-center justify-evenly border-[1px] border-[#755FFF] py-1 mx-[4%] lg:mt-6 md:mt-5 sm:mt-4 rounded-lg">
                <h1 id="tool-installation" class="text-white  text-[16px] font-thin">
                  /bin/bash -c "$(curl -fsSL <%= @url %>/linux.sh)"
                </h1>
                <button
                  id="copy"
                  phx-hook="CopyHook"
                  class="text-white bg-[#755FFF] py-1 px-2 rounded-lg text-[16px]  lg:text-[16px] md:text-[15px] sm:text-[14px]"
                >
                  Copy
                </button>
              </div>
              <h1 class="text-white lg:mt-4 md:mt-5 sm:mt-4">
                2. Open Terminal by pressing <b class="font-extrabold">Ctrl + Alt + T</b> together
              </h1>
              <h1 class="text-white lg:mt-3 md:mt-5 sm:mt-4">
                3. Paste the shell command by hitting <b>Ctrl + Alt + V</b> together
              </h1>
              <h1 class="text-white lg:mt-3 md:mt-5 sm:mt-4">
                4. Run the command by hitting <b>ENTER</b>
              </h1>
            </div>
          </div>
          <.link patch={~p"/"}>
            <button class="border-[#755FFF] border-[1px] lg:mt-8 md:mt-5 sm:mt-5 p-1 text-[#755FFF] text-[16px] rounded-md lg:ml-3">
              Back
            </button>
          </.link>
        </div>
      </div>
    </div>
    """
  end

  def render(%{page: :macOS} = assigns) do
    ~H"""
    <div class="solved-height font-normal">
      <div class="w-full h-full flex items-center justify-center">
        <div class="block lg:mt-[3%]">
          <h1 class="text-white text-center lg:text-[24px] md:text-[22px] sm:text-[20px] lg:mb-[5%] md:mb-[2%] sm:mb-[2%]">
            macOS installation process
          </h1>
          <div class="lg:w-[683px] lg:h-[304px] md:w-[683px] md:h-[300px] sm:w-[330px] sm:h-[400px] border-[4px] shadow-[#28177E] shadow-md border-[#211666] rounded-md lg:mx-[2%]">
            <div class="text-start px-[3%] lg:text-[20px] md:text-[18px] sm:text-[15px]">
              <h1 class="text-white lg:mt-4 md:mt-5 sm:mt-4">
                1. Press the button to copy this command to your clipboard:
              </h1>
              <div class="flex items-center justify-evenly border-[1px] border-[#755FFF] py-1 mx-[4%] lg:mt-6 md:mt-5 sm:mt-4 rounded-lg">
                <h1 id="tool-installation" class="text-white text-center text-[16px] font-thin">
                  /bin/bash -c "$(curl -fsSL <%= @url %>/macOS.sh)"
                </h1>
                <button
                  id="copy"
                  phx-hook="CopyHook"
                  class="text-white bg-[#755FFF] py-1 px-2 rounded-lg lg:text-[16px] md:text-[15px] sm:text-[14px]"
                >
                  Copy
                </button>
              </div>
              <h1 class="text-white lg:mt-4 md:mt-4 sm:mt-4">
                2. Open Terminal by pressing <b class="font-extrabold"> ⌘ + SPACE </b> together
              </h1>
              <h1 class="text-white lg:mt-3 md:mt-4 sm:mt-4">
                3. Type "Terminal" and hit <b>RETURN</b>
              </h1>
              <h1 class="text-white lg:mt-3 md:mt-4 sm:mt-4">
                4. Paste the shell command by hitting<b> ⌘ + V </b> together.
              </h1>
              <h1 class="text-white lg:mt-3 md:mt-4 sm:mt-4">
                5. Run the command by hitting <b>RETURN</b>
              </h1>
            </div>
          </div>
          <.link patch={~p"/"}>
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
