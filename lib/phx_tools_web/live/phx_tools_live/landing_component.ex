defmodule PhxToolsWeb.PhxToolsLive.LandingComponent do
  @moduledoc """
  Shows the landing page
  """
  use PhxToolsWeb, :html

  @spec landing_page(map()) :: Phoenix.LiveView.Rendered.t()
  def landing_page(assigns) do
    ~H"""
    <div class="solved-height">
      <div class="min-w-full min-h-full flex items-center justify-center">
        <div class="block mt-[5%]">
          <h1 class="text-white text-center lg:text-[24px] md:text-[20px] sm:text-[18px] mb-[10%]">
            Choose your operating system
          </h1>
          <div class="flex justify-between lg:px-4 md:px-8 sm:px-10">
            <.os_link_card
              id="macOS"
              href={~p"/macOS"}
              os_icon={~p"/images/macos.png"}
              os_name="macOS"
              class={[
                "px-3",
                @operating_system == "Mac" && "bg-indigo-850"
              ]}
            />
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

          <%= if @operating_system do %>
            <h1 id="confirmation" class="text-center text-white text-[20px] mt-[20%]">
              Confirm your choice by clicking
            </h1>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
