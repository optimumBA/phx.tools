defmodule PhxToolsWeb.SeoMetaTagComponentTest do
  use PhxToolsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias PhxToolsWeb.SeoMetaTagComponent

  describe "seo_meta_tags/1" do
    test "renders meta tags with default values" do
      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta name=\"twitter:card\" content=\"summary_large_image\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta name=\"twitter:description\" content=\"Phx.tools is a shell script for Linux and macOS that configures\nthe development environment for you in a few easy steps.\nOnce you finish running the script, you&#39;ll be able to start the database server,\ncreate a new Phoenix application, and launch the server...\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta name=\"twitter:image\" content=\"http://localhost:4002/images/phx_tools.png\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta name=\"twitter:site\" content=\"@optimumBA\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta name=\"twitter:title\" content=\"The Complete Development Environment for Elixir and Phoenix\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta name=\"twitter:type\" content=\"website\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta name=\"twitter:url\" content=\"http://localhost:4002/\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta property=\"description\" content=\"Phx.tools is a shell script for Linux and macOS that configures\nthe development environment for you in a few easy steps.\nOnce you finish running the script, you&#39;ll be able to start the database server,\ncreate a new Phoenix application, and launch the server...\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta property=\"og:description\" content=\"Phx.tools is a shell script for Linux and macOS that configures\nthe development environment for you in a few easy steps.\nOnce you finish running the script, you&#39;ll be able to start the database server,\ncreate a new Phoenix application, and launch the server...\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta property=\"og:image\" content=\"http://localhost:4002/images/phx_tools.png\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta property=\"og:title\" content=\"The Complete Development Environment for Elixir and Phoenix\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta property=\"og:type\" content=\"website\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: nil) =~
               "<meta property=\"og:url\" content=\"http://localhost:4002/\">"
    end

    test "renders meta tags with the values passed" do
      assigns = %{url: "http://sample.link"}

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: assigns) =~
               "<meta name=\"twitter:url\" content=\"http://sample.link\">"

      assert render_component(&SeoMetaTagComponent.seo_meta_tags/1, attributes: assigns) =~
               "<meta property=\"og:url\" content=\"http://sample.link\">"
    end
  end
end
