defmodule PhxToolsWeb.PhxToolsLive.ShowInstructionsComponent do
  use PhxToolsWeb, :html
  # alias Phoenix.LiveView.JS
  alias PhxToolsWeb.Endpoint
  alias PhxToolsWeb.InstructionComponents

  slot :installation_command, required: true

  def show_instructions(assigns) do
    ~H"""
    <%!-- <div class="flex-col justify-center w-full sm:py-2 md:flex lg:w-9/12">
      <div class="md:flex">
        <div class="flex justify-end sm:py-4 md:py-0 md:order-last md:mx-2">
          <img src="/images/info_icon.svg" alt="installation command info" />
        </div>
        <div class="border sm:px-3 bg-[#26168780] w-full flex items-center justify-center py-2 sm:space-x-3 rounded-sm">
          <h1 id="tool-installation" class="text-center text-white font-martian sm:text-sm">
            <%= render_slot(@installation_command) %>
          </h1>
          <div id="copy" phx-hook="CopyHook" class="sm:py-3 md:my-0">
            <img
              src="/images/clipboard.svg"
              alt="copy icon"
              phx-click={JS.show(to: "#installation-instructions")}
            />
          </div>
        </div>
      </div>
      <div
        id="installation-instructions"
        phx-click-away={JS.hide(to: "#installation-instructions")}
        class="w-full bg-green-400 top-20"
      >
      </div>
    </div> --%>

    <%= case @live_action do %>
      <% :linux -> %>
        <InstructionComponents.os_instructions>
          <:header>
            Linux installation process
          </:header>

          <:installation_command>
            <%= "/bin/bash -c \"$(curl -fsSL #{Endpoint.url() <> "/Linux.sh"})\"" %>
          </:installation_command>

          <:instruction>
            2. Open Terminal by pressing <b class="font-extrabold">Ctrl + Alt + T</b> together
          </:instruction>

          <:instruction>
            3. Paste the shell command by pressing <b>Shift + Ctrl + V</b> together
          </:instruction>

          <:instruction>
            4. Run the command by hitting <b>ENTER</b>
          </:instruction>
        </InstructionComponents.os_instructions>
      <% :macOS -> %>
        <InstructionComponents.os_instructions>
          <:header>
            macOS installation process
          </:header>

          <:installation_command>
            <%= "/bin/bash -c \"$(curl -fsSL #{Endpoint.url() <> "/macOS.sh"})\"" %>
          </:installation_command>

          <:instruction>
            2. Open Terminal by pressing <b class="font-extrabold"> ⌘ + SPACE </b> together
          </:instruction>

          <:instruction>
            3. Type "Terminal" and hit <b>RETURN</b>
          </:instruction>

          <:instruction>
            4. Paste the shell command by hitting<b> ⌘ + V </b> together.
          </:instruction>

          <:instruction>
            5. Run the command by hitting <b>RETURN</b>
          </:instruction>
        </InstructionComponents.os_instructions>
    <% end %>
    """
  end
end
