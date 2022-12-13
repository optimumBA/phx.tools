defmodule PhxToolsWeb.ErrorHTML do
  @moduledoc false

  use PhxToolsWeb, :html

  # If you want to customize your error pages,
  # uncomment the embed_templates/1 call below
  # and add pages to the error directory:
  #
  #   * lib/phx_tools_web/controllers/error/404.html.heex
  #   * lib/phx_tools_web/controllers/error/500.html.heex
  #
  # embed_templates "error/*"

  # The default is to render a plain text page based on
  # the template name. For example, "404.html" becomes
  # "Not Found".
  @spec render(String.t(), Keyword.t()) :: String.t()
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
