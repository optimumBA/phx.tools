defmodule PhxToolsWeb.SeoMetaTagComponent do
  @moduledoc false

  use PhxToolsWeb, :html

  alias PhxToolsWeb.Endpoint

  @type assigns :: map()
  @type rendered :: rendered()

  @default_description """
  Phx.tools is a shell script for Linux and macOS that configures
  the development environment for you in a few easy steps.
  Once you finish running the script, you'll be able to start the database server,
  create a new Phoenix application, and launch the server...
  """

  attr :attributes, :map

  @spec seo_meta_tags(assigns()) :: rendered()
  def seo_meta_tags(assigns) do
    assigns =
      assigns
      |> assign_new(:description, fn -> String.trim(@default_description) end)
      |> assign_new(:image_url, fn -> static_url(Endpoint, ~p"/images/phx_tools.png") end)
      |> assign_new(:url, fn
        %{attributes: %{url: url}} -> url
        _assigns -> url(~p"/")
      end)

    ~H"""
    <.open_graph_meta_tags description={@description} image_url={@image_url} url={@url} />
    <.other_meta_tags
      description={@description}
      keywords="elixir, erlang, homebrew, mise, phoenix, postgres, postgresql"
    />
    <.twitter_meta_tags description={@description} image_url={@image_url} url={@url} />
    """
  end

  attr :description, :string, required: true
  attr :image_url, :string, required: true
  attr :url, :string, required: true

  defp open_graph_meta_tags(assigns) do
    ~H"""
    <meta property="og:description" content={@description} />
    <meta property="og:image" content={@image_url} />
    <meta property="og:title" content="The Complete Development Environment for Elixir and Phoenix" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content={@url} />
    """
  end

  attr :description, :string, required: true
  attr :keywords, :string, required: true

  defp other_meta_tags(assigns) do
    ~H"""
    <meta property="description" content={@description} />
    <meta name="keywords" content="elixir, erlang, homebrew, mise, phoenix, postgres, postgresql" />
    """
  end

  attr :description, :string, required: true
  attr :image_url, :string, required: true
  attr :url, :string, required: true

  defp twitter_meta_tags(assigns) do
    ~H"""
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:description" content={@description} />
    <meta name="twitter:image" content={@image_url} />
    <meta name="twitter:site" content="@optimumBA" />
    <meta name="twitter:title" content="The Complete Development Environment for Elixir and Phoenix" />
    <meta name="twitter:type" content="website" />
    <meta name="twitter:url" content={@url} />
    """
  end
end
