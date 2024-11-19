defmodule PhxToolsWeb.PhxToolsLive.Icons do
  @moduledoc false

  use PhxToolsWeb, :html

  @type assigns :: map()
  @type rendered :: Phoenix.LiveView.Rendered.t()

  @spec copied_icon(assigns()) :: rendered()
  def copied_icon(assigns) do
    ~H"""
    <svg
      id="copied-icon"
      xmlns="http://www.w3.org/2000/svg"
      class="icon icon-tabler icon-tabler-circle-check hidden"
      viewBox="0 0 24 24"
      width="44"
      height="24"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="white"
      fill="none"
      stroke-linecap="round"
      stroke-linejoin="round"
    >
      <path stroke="none" d="M0 0h24v24H0z" fill="none" />
      <path d="M12 12m-9 0a9 9 0 1 0 18 0a9 9 0 1 0 -18 0" />
      <path d="M9 12l2 2l4 -4" />
    </svg>
    """
  end

  attr :class, :string, default: nil

  @spec copy_icon(assigns()) :: rendered()
  def copy_icon(assigns) do
    ~H"""
    <svg
      id="copy-icon"
      width="18"
      height="20"
      viewBox="0 0 18 20"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      class={@class}
    >
      <path
        d="M5 3H3C1.89543 3 1 3.89543 1 5V17C1 18.1046 1.89543 19 3 19H13C14.1046 19 15 18.1046 15 17V16M5 3C5 4.10457 5.89543 5 7 5H9C10.1046 5 11 4.10457 11 3M5 3C5 1.89543 5.89543 1 7 1H9C10.1046 1 11 1.89543 11 3M11 3H13C14.1046 3 15 3.89543 15 5V8M17 12H7M7 12L10 9M7 12L10 15"
        stroke="white"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
    </svg>
    """
  end

  @spec exclamation_icon(assigns()) :: rendered()
  def exclamation_icon(assigns) do
    ~H"""
    <svg
      width="22"
      height="22"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="currentColor"
    >
      <path
        fill-rule="evenodd"
        d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12ZM12 8.25a.75.75 0 0 1 .75.75v3.75a.75.75 0 0 1-1.5 0V9a.75.75 0 0 1 .75-.75Zm0 8.25a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Z"
        clip-rule="evenodd"
      />
    </svg>
    """
  end

  @spec optimum_logo(assigns()) :: rendered()
  def optimum_logo(assigns) do
    ~H"""
    <svg width="37" height="37" viewBox="0 0 37 37" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M18.2272 36.4544C28.2937 36.4544 36.4544 28.2937 36.4544 18.2272C36.4544 8.1606 28.2937 0 18.2272 0C8.1606 0 0 8.1606 0 18.2272C0 28.2937 8.1606 36.4544 18.2272 36.4544ZM18.2272 27.3408C23.2605 27.3408 27.3408 23.2605 27.3408 18.2272C27.3408 13.1939 23.2605 9.11361 18.2272 9.11361C13.1939 9.11361 9.11361 13.1939 9.11361 18.2272C9.11361 23.2605 13.1939 27.3408 18.2272 27.3408Z"
        fill="url(#paint0_linear_56_374)"
      />
      <defs>
        <linearGradient
          id="paint0_linear_56_374"
          x1="0"
          y1="18.2272"
          x2="46.245"
          y2="18.2272"
          gradientUnits="userSpaceOnUse"
        >
          <stop stop-color="#5433FF" />
          <stop offset="0.5" stop-color="#20BDFF" />
          <stop offset="1" stop-color="#A5FECB" />
        </linearGradient>
      </defs>
    </svg>
    """
  end

  attr :class, :string, default: nil
  @spec phx_tools_svg(assigns()) :: rendered()
  def phx_tools_svg(assigns) do
    ~H"""
    <svg class={@class} viewBox="0 0 290 39" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path
        d="M0.722222 39V0.888888H6.16667H22.5V6.33333H27.9444V17.2222H22.5V22.6667H6.16667V39H0.722222ZM22.5 17.2222V6.33333H6.16667V17.2222H22.5ZM44.2937 11.7778H55.1826V17.2222H60.6271V39H55.1826V17.2222H44.2937V11.7778ZM33.4048 0.888888H38.8493V17.2222H44.2937V22.6667H38.8493V39H33.4048V0.888888ZM82.4208 22.6667V28.1111H87.8652V33.5556H93.3097V39H87.8652H82.4208V33.5556V28.1111H76.9763V22.6667H82.4208ZM82.4208 22.6667V17.2222V11.7778H87.8652H93.3097V17.2222H87.8652V22.6667H82.4208ZM76.9763 22.6667H71.5319V17.2222H66.0875V11.7778H71.5319H76.9763V17.2222V22.6667ZM76.9763 28.1111V33.5556V39H71.5319H66.0875V33.5556H71.5319V28.1111H76.9763ZM109.659 39V33.5556H115.103V39H109.659ZM158.675 33.5556V39H142.342V33.5556H136.897V17.2222H131.453V11.7778H136.897V0.888888H142.342V11.7778H153.23V17.2222H142.342V33.5556H158.675ZM169.58 17.2222V33.5556H164.135V17.2222H169.58ZM169.58 17.2222V11.7778H185.913V17.2222H169.58ZM185.913 17.2222H191.358V33.5556H185.913V17.2222ZM169.58 33.5556H185.913V39H169.58V33.5556ZM202.262 17.2222V33.5556H196.818V17.2222H202.262ZM202.262 17.2222V11.7778H218.596V17.2222H202.262ZM218.596 17.2222H224.04V33.5556H218.596V17.2222ZM202.262 33.5556H218.596V39H202.262V33.5556ZM245.834 33.5556H256.723V39H245.834V33.5556ZM245.834 33.5556H240.389V6.33333H234.945V0.888888H240.389H245.834V33.5556ZM267.628 11.7778H289.405V17.2222H267.628V11.7778ZM283.961 33.5556V28.1111H267.628V22.6667H262.183V17.2222H267.628V22.6667H283.961V28.1111H289.405V33.5556H283.961ZM283.961 33.5556V39H262.183V33.5556H283.961Z"
        fill="white"
      />
    </svg>
    """
  end
end
