defmodule PhxToolsWeb.PhxToolsLive.UnsupportedOsComponent do
  use PhxToolsWeb, :html

  @spec unsupported_os_page(map()) :: Phoenix.LiveView.Rendered.t()
  def unsupported_os_page(assigns) do
    ~H"""
    <div class="md:mx-8">
      <div>
        <div>
          <h1 class="font-extrabold text-center text-white lg:text-7xl md:text-xl sm:text-4xl font-pixelify">
            Phx.tools
          </h1>
          <p class="py-5 text-center text-white md:text-md font-martian sm:text-xs">
            The Complete Development Environment for Elixir and Phoenix
          </p>
        </div>
      </div>
      <div class="bg-[#110A33] rounded-xl shadow-md text-white shadow-white ">
        <div class="bg-[#2C2650] sm:p-3 rounded-t-xl md:flex items-center md:space-x-4 justify-center">
          <img src="/images/warn_icon.svg" alt="unsupported operating system" />
          <p class="sm:pt-3 font-martian">Unsupported Operating System Detected</p>
        </div>
        <p class="text-sm text-center sm:px-2 font-martian sm:py-6">
          It looks like you're using an operating system that Phx.tools doesn't currently support. This script is designed to work on Linux and macOS only. Please switch to a compatible operating system to continue.
        </p>
        <div class="flex-col items-center text-sm sm:flex font-martian sm:pb-6 md:block md:text-center">
          <a href="https://phx.tools/macOS" class="text-[#24B2FF] underline">
            https://phx.tools/macOS
          </a>
          <span>or</span>
          <a href="http://phx.tools/linux" class="text-[#24B2FF] underline">
            http://phx.tools/linux"
          </a>
        </div>
      </div>
      <div>
        <p class="text-center text-white font-martian sm:text-sm sm:py-12">
          Phx.tools is a shell script for Linux and macOS that configures the development environment for you in a few easy steps. Once you finish running the script, you'll be able to start the database server, create a new Phoenix application, and launch the server.
        </p>
        <p class="text-[#24B2FF] font-martian text-center text-sm sm:pb-4">
          <a href="https://optimum.ba/blog/phx-tools-complete-development-environment-for-elixir-and-phoenix">
            <span class="text-white">Read about website updates here</span>
            - https://optimum.ba/blog/phx-tools-complete-development-environment-for-elixir-and-phoenix
          </a>
        </p>
      </div>
    </div>
    """
  end
end
