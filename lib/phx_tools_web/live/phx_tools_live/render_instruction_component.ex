defmodule PhxToolsWeb.PhxToolsLive.RenderInstructionComponent do
  use PhxToolsWeb, :html

  alias PhxToolsWeb.InstructionComponents

  attr :live_action, :string, required: true
  attr :operating_system, :string, required: true

  @spec render_instructions(map()) :: Phoenix.LiveView.Rendered.t()
  def render_instructions(assigns) do
    ~H"""
    <%= case @live_action do %>
      <% :linux -> %>
        <InstructionComponents.os_instructions>
          <:header>
            Linux installation process
          </:header>

          <:instruction>
            1. Click on the copy icon to copy this command to your clipboard
          </:instruction>
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

          <:instruction>
            1. Click on the copy icon to copy this command to your clipboard
          </:instruction>

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
