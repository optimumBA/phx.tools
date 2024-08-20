defmodule PhxToolsWeb.PhxToolsLive.UnsupportedOsComponent do
  use PhxToolsWeb, :html

  alias PhxToolsWeb.PhxToolsComponents
  alias PhxToolsWeb.PhxToolsLive.Icons

  @spec unsupported_os_page(map()) :: Phoenix.LiveView.Rendered.t()
  def unsupported_os_page(assigns) do
    ~H"""
    <div class="flex flex-col items-center max-w-5xl mx-auto">
      <div>
        <div class="sm:flex flex-col items-center">
          <Icons.phx_tools_svg class="sm:w-4/12" />
          <p class="sm:py-6 text-center text-white md:text-xl font-martian text-sm font-semibold ">
            The Complete Development Environment for Elixir and Phoenix
          </p>
        </div>
      </div>
      <div class="flex flex-col items-center md:w-11/12 lg:w-[1300px]">
        <div class="bg-[#110A33] rounded-xl shadow-lg text-white shadow-[#2C2650] blur-shadow max-w-[809px]">
          <div class="bg-[#2C2650] sm:p-3 rounded-t-xl md:flex items-center md:space-x-4 justify-center">
            <Icons.exclamation_icon />
            <p class="font-martian sm:text-base md:text-[1.375rem] md:py-2">
              Unsupported Operating System Detected
            </p>
          </div>
          <p class="sm:text-sm sm:leading-6 md:text-base text-center sm:px-3  font-martian sm:py-6 md:px-8">
            It looks like you're using an operating system that Phx.tools doesn't currently support. This script is designed to work on Linux and macOS only. Please switch to a compatible operating system to continue.
          </p>
          <div class="flex-col items-center text-sm sm:flex font-martian sm:pb-8 md:block md:text-center">
            <a href="https://phx.tools/macOS" class="text-[#24B2FF] underline">
              https://phx.tools/macOS
            </a>
            <span class="px-2">or</span>
            <a href="http://phx.tools/linux" class="text-[#24B2FF] underline">
              http://phx.tools/linux"
            </a>
          </div>
        </div>
        <p class="text-center text-white font-martian sm:text-sm md:text-xl sm:py-8">
          Phx.tools is a shell script for Linux and macOS that configures the development environment for you in a few easy steps. Once you finish running the script, you'll be able to start the database server, create a new Phoenix application, and launch the server.
        </p>
      </div>
      <div class="">
        <p class="text-white font-martian text-center sm:text-sm md:text-xl sm:pb-4">
          Read about website updates here -
          <a
            href="https://optimum.ba/blog/phx-tools-complete-development-environment-for-elixir-and-phoenix"
            target="_blank"
            class="text-[#24B2FF] underline"
          >
            https://optimum.ba/blog/phx-tools-complete-development-environment-for-elixir-and-phoenix
          </a>
        </p>
      </div>
      <PhxToolsComponents.footer />
    </div>
    """
  end
end
