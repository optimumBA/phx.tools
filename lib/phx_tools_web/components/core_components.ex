defmodule PhxToolsWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  The components in this module use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn how to
  customize the generated components in this module.

  Icons are provided by [heroicons](https://heroicons.com), using the
  [heroicons_elixir](https://github.com/mveytsman/heroicons_elixir) project.
  """
  use Phoenix.Component

  import PhxToolsWeb.Gettext

  alias Phoenix.LiveView.JS
  alias Phoenix.LiveView.Rendered

  @type assigns :: map()
  @type js :: %JS{}
  @type rendered :: Rendered.t()
  @type selector :: String.t()

  @doc """
  Renders a card for being able to select OS
  """
  attr :id, :string, required: true
  attr :class, :list
  attr :href, :string, required: true
  attr :os_icon, :string, required: true
  attr :os_name, :string, required: true
  attr :source_code, :string, required: true

  @spec os_link_card(assigns()) :: rendered()
  def os_link_card(assigns) do
    ~H"""
    <div class="sm:grid grid-cols-2 gap-4 sm:py-4">
      <.link href={@href}>
        <div
          id={@id}
          class={[
            "border-[2px] border-[#755FFF] py-2 rounded-xl cursor-pointer hover:bg-indigo-850 flex items-center md:w-44",
            @class
          ]}
        >
          <img src={@os_icon} class="h-7 w-7 " />
          <h1 class="text-center text-white font-martian"><%= @os_name %></h1>
        </div>
      </.link>
      <div class="border-[2px] border-[#755FFF] rounded-xl cursor-pointer hover:bg-indigo-850 flex font-martian md:w-44">
        <.link
          navigate={@source_code}
          class="flex items-center justify-center w-full space-x-2 text-sm rounded-xl"
        >
          <span><img src="/images/Icon.svg" alt="" /></span>
          <span class="text-white">Source code</span>
        </.link>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, default: "flash", doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :autoshow, :boolean, default: true, doc: "whether to auto show the flash on mount"
  attr :close, :boolean, default: true, doc: "whether the flash can be closed"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  @spec flash(assigns()) :: rendered()
  def flash(assigns) do
    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-mounted={@autoshow && show("##{@id}")}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("#flash")}
      role="alert"
      class={[
        "fixed hidden top-2 right-2 w-80 sm:w-96 z-50 rounded-lg p-3 shadow-md shadow-zinc-900/5 ring-1",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 p-3 text-rose-900 shadow-md ring-rose-500 fill-rose-900"
      ]}
      {@rest}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-[0.8125rem] font-semibold leading-6">
        <Heroicons.information_circle :if={@kind == :info} mini class="w-4 h-4" />
        <Heroicons.exclamation_circle :if={@kind == :error} mini class="w-4 h-4" />
        <%= @title %>
      </p>
      <p class="mt-2 text-[0.8125rem] leading-5"><%= msg %></p>
      <button
        :if={@close}
        type="button"
        class="absolute p-2 group top-2 right-1"
        aria-label={gettext("close")}
      >
        <Heroicons.x_mark solid class="w-5 h-5 stroke-current opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  @spec back(assigns()) :: rendered()
  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <Heroicons.arrow_left solid class="inline w-3 h-3 stroke-current" />
        <%= render_slot(@inner_block) %>
      </.link>
    </div>
    """
  end

  ## JS Commands

  @spec show(js(), selector()) :: js()
  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  @spec hide(js(), selector()) :: js()
  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end
end
